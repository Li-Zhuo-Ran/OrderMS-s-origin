from django.db import models


# 菜品类型
class Foodtype(models.Model):
    ID = models.AutoField(primary_key=True)
    name = models.CharField(max_length=20, verbose_name="类型")

    def __str__(self):
        return self.name

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '菜品类型表'
        verbose_name_plural = '菜品类型表'


# 菜品
class Food(models.Model):
    ID = models.AutoField(primary_key=True)
    title = models.CharField(max_length=20, verbose_name="菜品名称")
    amount = models.IntegerField(default=0, verbose_name="剩余数量")
    price = models.FloatField(default=0, verbose_name="价格")
    cost_time = models.IntegerField(default=0, verbose_name="制作时间")
    foodType = models.ForeignKey('Foodtype', to_field="ID", on_delete=models.PROTECT, verbose_name="类型")

    def __str__(self):
        return self.title

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '菜品信息表'
        verbose_name_plural = '菜品信息表'


# 订单信息表
class Order(models.Model):
    ID = models.AutoField(primary_key=True)
    create_time = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")
    pay_time = models.DateTimeField(null=True, verbose_name="支付时间")
    is_pay = models.BooleanField(default=False, verbose_name="是否支付")
    food_amount = models.IntegerField(default=0, verbose_name="菜品总数")
    total_price = models.FloatField(default=0, verbose_name="总价")
    table_id = models.IntegerField(default=0, verbose_name="桌号")
    comment = models.CharField(max_length=50, default='', verbose_name="备注")
    staff = models.ForeignKey(
        'Staff', on_delete=models.DO_NOTHING, verbose_name="员工")  # 当时负责的员工

    def __str__(self):
        return 'Order ' + str(self.ID)

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '订单信息表'
        verbose_name_plural = '订单信息表'


# 订单状态表
class OrderItem(models.Model):
    class KitchenStatus(models.IntegerChoices):
        PENDING = 0, '待接单'
        ACCEPTED = 1, '已接单'
        COOKING = 2, '制作中'
        READY_TO_SERVE = 3, '待上菜'
        SERVED = 4, '已上菜'
        CANCELED = 5, '已取消'

    STATUS_TRANSITIONS = {
        KitchenStatus.PENDING: {KitchenStatus.ACCEPTED, KitchenStatus.CANCELED},
        KitchenStatus.ACCEPTED: {KitchenStatus.COOKING, KitchenStatus.CANCELED},
        KitchenStatus.COOKING: {KitchenStatus.READY_TO_SERVE, KitchenStatus.CANCELED},
        KitchenStatus.READY_TO_SERVE: {KitchenStatus.SERVED},
        KitchenStatus.SERVED: set(),
        KitchenStatus.CANCELED: set(),
    }

    orderID = models.ForeignKey('Order', on_delete=models.CASCADE, verbose_name="订单")
    foodID = models.ForeignKey('Food', on_delete=models.DO_NOTHING, verbose_name="菜品")
    amount = models.IntegerField(default=1)
    sum_price = models.FloatField(default=0, verbose_name="总价")
    status = models.IntegerField(
        default=KitchenStatus.PENDING,
        choices=KitchenStatus.choices,
        verbose_name="状态",
    )
    start_cook_time = models.TimeField(null=True, verbose_name="开始制作时间")
    end_cook_time = models.TimeField(null=True, verbose_name="制作结束时间")
    comment = models.CharField(max_length=50, verbose_name="备注")

    def __str__(self):
        return self.foodID.title + ' in Order ' + str(self.orderID.ID)

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '订单状态表'
        verbose_name_plural = '订单状态表'

    def can_transition_to(self, target_status):
        return target_status in self.STATUS_TRANSITIONS.get(
            self.KitchenStatus(self.status), set()
        )

    def transition_to(self, target_status):
        target_status = self.KitchenStatus(target_status)
        if not self.can_transition_to(target_status):
            raise ValueError(
                f'非法状态流转：{self.get_status_display()} -> {target_status.label}'
            )
        self.status = target_status


# 员工信息表
class Staff(models.Model):
    ID = models.AutoField(primary_key=True)  # 员工ID
    citizenID = models.CharField(max_length=20, verbose_name="证件号码")  # 身份证件号
    name = models.CharField(max_length=10, verbose_name="姓名")
    gender = models.CharField(max_length=20, choices=(
        ('male', '男'), ('female', '女')), default='male', verbose_name="性别")
    born_date = models.DateField(null=True, verbose_name="出生日期")
    phone = models.CharField(max_length=11, verbose_name="电话号码")
    address = models.CharField(max_length=50, default='', verbose_name="住址")

    def __str__(self):
        return self.name

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '员工信息表'
        verbose_name_plural = '员工信息表'


# 餐桌管理信息表
class Staff_Table(models.Model):
    ID = models.IntegerField(default=0, primary_key=True)
    name = models.CharField(max_length=20, verbose_name="桌名")
    staff = models.ForeignKey('Staff', on_delete=models.DO_NOTHING, verbose_name="负责员工")

    def __str__(self):
        return str(self.ID) + ' ' + self.name

    class Meta:
        # 设置Admin的显示内容
        verbose_name = '餐桌信息表'
        verbose_name_plural = '餐桌信息表'

# 评价表
class Review(models.Model):
    name = models.CharField(max_length=100, blank=True, null=True, verbose_name="姓名")
    rating = models.IntegerField(verbose_name="评分", choices=[(i, f"{i}星") for i in range(1, 6)])
    comment = models.TextField(verbose_name="评价内容")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

    class Meta:
        verbose_name = "评价"
        verbose_name_plural = "评价"
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.name or '匿名'} - {self.rating}星"

# python manage.py makemigrations
# python manage.py migrate
# python manage.py createsuperuser
