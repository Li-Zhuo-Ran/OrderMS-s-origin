from django.shortcuts import render, redirect
from django.http import HttpResponse
from .models import Food, Foodtype, Order, OrderItem, Staff, Staff_Table
from django.contrib.auth.decorators import login_required
from django.db import connection
from django.http import JsonResponse
from .models import Review
from . import forms
import json
import datetime
from django.contrib import messages # 导入消息框架
from django.views.decorators.csrf import ensure_csrf_cookie


def home(request):
    return render(request, "home.html")




@login_required(login_url='/order/signin/')
@ensure_csrf_cookie
def OrderHome(request):
    if request.method == "GET":
        foodList = Food.objects.all()
        foodTypeList = Foodtype.objects.all()
        tableList = Staff_Table.objects.all()
        return render(
            request,
            'OrderHome.html',
            {
                'foodList': foodList,
                'foodTypeList': foodTypeList,
                'tableList': tableList,
            }
        )
    elif request.method == "POST":
        foodList = json.loads(request.POST.get('foodList'))
        table_id = request.POST.get('table')

        # 创建订单 填写基本信息
        new_order = Order(table_id=table_id, is_pay=False)
        staff_in_charge = Staff_Table.objects.get(pk=table_id).staff
        new_order.staff = staff_in_charge  # 当前桌子的负责人
        new_order.save()

        # 先 save 再获取 ID
        order_id = new_order.ID
        food_amount = 0
        total_price = 0

        for food in foodList:
            curFood = Food.objects.get(pk=food['id'])
            price = curFood.price
            sum_price = price * food['amount']
            curFood.amount -= food['amount']
            curFood.save()

            food_amount += food['amount']
            total_price += sum_price

            OrderItem.objects.create(
                orderID=new_order,
                foodID=curFood,
                amount=food['amount'],
                sum_price=sum_price
            )
        # 订单的物品总数、总价
        new_order.food_amount = food_amount
        new_order.total_price = total_price
        new_order.save()

        return HttpResponse(json.dumps({
            'order_id': order_id
        }))


# 02账单详情页
@login_required(login_url='/order/signin/')
@ensure_csrf_cookie
def QueryOrder(request, order_id):
    try:
        order = Order.objects.get(pk=order_id)
    except:
        return HttpResponse('无此订单！')

    foodList = Food.objects.filter(orderitem__orderID__ID=order_id)

    with connection.cursor() as cursor:
        SELECT_COL = 'OrderSystem_food.ID ID, OrderSystem_food.title title, OrderSystem_orderitem.amount amount'
        SELECT_COL += ', OrderSystem_orderitem.sum_price '
        SELECT_COL += ', OrderSystem_orderitem.start_cook_time '
        SELECT_COL += ', OrderSystem_orderitem.end_cook_time '
        SELECT_FROM = 'OrderSystem_food, OrderSystem_orderitem '
        SELECT_WHERE = 'OrderSystem_food.ID=OrderSystem_orderitem.foodID_id '
        SELECT_WHERE += ' and OrderSystem_orderitem.orderID_id={0}'.format(
            order_id)
        cursor.execute(
            f'select {SELECT_COL} from {SELECT_FROM} where {SELECT_WHERE}')
        foodJsonList = dictfetchall(cursor)

    return render(request, 'QueryOrder.html', {
        'order': order,
        'foodList': foodJsonList,
    })


# 03待结账页面
@login_required
@ensure_csrf_cookie
def CheckUnpaidOrder(request):
    # 查询当前未结账订单
    orderList = []
    with connection.cursor() as cursor:
        SELECT_COL = 'ID, create_time, table_id, total_price'
        SELECT_FROM = 'OrderSystem_order'
        SELECT_WHERE = 'is_pay=0'  # 0 false
        SELECT = f'select {SELECT_COL} from {SELECT_FROM} where {SELECT_WHERE}'
        cursor.execute(SELECT)
        orderList = dictfetchall(cursor)
        print(orderList)

    return render(request, 'CheckUnpaidOrder.html', {
        'orderList': orderList,
    })


# 04结账
@login_required
def CheckOut(request):
    if request.method == "POST":
        order_list = json.loads(request.POST.get('order_list'))
        print(order_list)
        for order_data in order_list:
            print(order_data)
            order_id = order_data['order_id']
            is_pay = order_data['is_pay']

            if is_pay:
                order = Order.objects.get(pk=order_id)
                if order.is_pay:
                    print("已经支付！")
                    return HttpResponse(json.dumps({
                        'status': 'ALREADY_PAY'
                    }))

                order.is_pay = True
                order.pay_time = datetime.datetime.now()
                order.save()
            else:
                return HttpResponse(json.dumps({
                    'status': 'NO_PAY'
                }))

        return HttpResponse(json.dumps({
            'status': 'OK'
        }))


# 05管理界面（餐位管理人）
@login_required
@ensure_csrf_cookie
def manage(request):
    staffList = Staff.objects.all()
    # (餐桌号 + 餐桌名字 + 负责人ID + 负责人姓名)
    tableInfoList = []
    with connection.cursor() as cursor:
        SELECT_COL = ' distinct {0}_staff_table.ID table_id '
        SELECT_COL += ', {0}_staff_table.name table_name '
        SELECT_COL += ', {0}_staff.ID staff_id '
        SELECT_COL += ', {0}_staff.name staff_name '
        SELECT_COL = SELECT_COL.format('OrderSystem')

        SELECT_FROM = '{0}_staff_table, {0}_staff '
        SELECT_FROM = SELECT_FROM.format('OrderSystem')

        SELECT_WHERE = '{0}_staff.ID = {0}_staff_table.staff_id '
        SELECT_WHERE = SELECT_WHERE.format('OrderSystem')

        SELECT_SQL = f'select {SELECT_COL} from {SELECT_FROM} where {SELECT_WHERE}'
        cursor.execute(SELECT_SQL)

        tableInfoList = dictfetchall(cursor)

    return render(request, 'manage.html', {
        'tableInfoList': tableInfoList,
        'staffList': staffList,
        'user': request.user,
    })


# 06 获取正在接受服务的餐位信息
@login_required
def getServingTableList(request):
    # (餐桌号 + 餐桌名字 + 负责人ID + 负责人姓名)
    servingTableList = []
    with connection.cursor() as cursor:
        SELECT_COL = 'distinct {0}_order.table_id table_id '
        SELECT_COL = SELECT_COL.format('OrderSystem')

        SELECT_FROM = '{0}_order '
        SELECT_FROM = SELECT_FROM.format('OrderSystem')

        SELECT_WHERE = '{0}_order.is_pay = 0 '  # false 0
        SELECT_WHERE = SELECT_WHERE.format('OrderSystem')

        SELECT_SQL = f'select {SELECT_COL} from {SELECT_FROM} where {SELECT_WHERE}'
        SELECT_SQL += 'order by table_id'
        cursor.execute(SELECT_SQL)

        servingTableInfoList = dictfetchall(cursor)
        for tableInfo in servingTableInfoList:
            servingTableList.append(tableInfo['table_id'])
    print(json.dumps(servingTableList))
    return HttpResponse(json.dumps({
        'servingTableList': servingTableList,
    }))


# 07后厨查看订单（接单或上菜）
@login_required
def getOrderItemList(request):
    if request.method == "POST":
        # 没有指定 order_id 就返回所有 order_item
        order_id = request.POST.get('order_id')
        order_items = (
            OrderItem.objects
            .select_related('orderID', 'foodID')
            .filter(orderID__is_pay=False)
            .order_by('orderID__table_id', 'orderID_id', 'foodID_id')
        )
        if order_id:
            order_items = order_items.filter(orderID_id=order_id)

        order_item_list = []
        for item in order_items:
            order_item_list.append({
                'orderID_id': item.orderID_id,
                'table_id': item.orderID.table_id,
                'foodID_id': item.foodID_id,
                'food_name': item.foodID.title,
                'food_amount': item.amount,
                'status': item.status,
                'status_display': item.get_status_display(),
            })

        return JsonResponse(order_item_list, safe=False)


# 08更新餐桌表中的员工
@login_required
def set_staff_charge_table(request):
    if request.method == "POST":
        table_id = request.POST.get("table_id")
        staff_id = request.POST.get("staff_id")
        try:
            Staff_Table.objects.filter(pk=table_id).update(staff_id=staff_id)
            return HttpResponse(json.dumps({
                'status': "OK"
            }))
        except:
            return HttpResponse(json.dumps({
                'status': "FAIL"
            }))


# 09上菜
@login_required
def delive_food(request):
    if request.method == "POST":
        order_id = request.POST.get("order_id")
        food_id = request.POST.get("food_id")
        try:
            order_item = OrderItem.objects.get(orderID_id=order_id, foodID_id=food_id)
        except OrderItem.DoesNotExist:
            return JsonResponse({
                'status': 'FAIL',
                'message': '未找到对应订单菜品',
            }, status=404)

        try:
            order_item.transition_to(OrderItem.KitchenStatus.SERVED)
        except ValueError as err:
            return JsonResponse({
                'status': 'INVALID_TRANSITION',
                'message': str(err),
            }, status=400)

        order_item.save(update_fields=['status'])
        return JsonResponse({
            'status': 'OK',
            'message': '已上菜',
            'current_status': order_item.status,
            'current_status_display': order_item.get_status_display(),
        })


# 10后厨界面
@login_required
@ensure_csrf_cookie
def food_supplier(request):
    return render(request, 'FoodSupplier.html')


# 11后厨接单或者呼叫上菜
@login_required
def cook(request):
    if request.method == "POST":
        action = request.POST.get("action") or request.POST.get("OP")
        order_id = request.POST.get("order_id")
        food_id = request.POST.get("food_id")
        action_map = {
            'accept_order': OrderItem.KitchenStatus.ACCEPTED,
            'start_cooking': OrderItem.KitchenStatus.COOKING,
            'mark_ready': OrderItem.KitchenStatus.READY_TO_SERVE,
            # 兼容旧参数
            'take_order': OrderItem.KitchenStatus.ACCEPTED,
            'ready_serve': OrderItem.KitchenStatus.READY_TO_SERVE,
        }

        if action not in action_map:
            return JsonResponse({
                'status': 'INVALID_ACTION',
                'message': '不支持的后厨操作',
            }, status=400)

        try:
            order_item = OrderItem.objects.get(orderID_id=order_id, foodID_id=food_id)
        except OrderItem.DoesNotExist:
            return JsonResponse({
                'status': 'FAIL',
                'message': '未找到对应订单菜品',
            }, status=404)

        try:
            order_item.transition_to(action_map[action])
        except ValueError as err:
            return JsonResponse({
                'status': 'INVALID_TRANSITION',
                'message': str(err),
            }, status=400)

        now = datetime.datetime.now().time()
        update_fields = ['status']
        if order_item.status == OrderItem.KitchenStatus.COOKING and not order_item.start_cook_time:
            order_item.start_cook_time = now
            update_fields.append('start_cook_time')
        if order_item.status == OrderItem.KitchenStatus.READY_TO_SERVE:
            order_item.end_cook_time = now
            update_fields.append('end_cook_time')
        order_item.save(update_fields=update_fields)

        return JsonResponse({
            'status': 'OK',
            'message': '状态更新成功',
            'current_status': order_item.status,
            'current_status_display': order_item.get_status_display(),
        })


# 辅助函数 数据库查询结果转换成 json/dict'''
def dictfetchall(cursor):
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]


# -------------管理功能 --------------
# 01订单管理
@login_required
def orders(request):
    orders = Order.objects.all()
    return render(request, 'manage/orders.html', {
        'orders': orders,
    })


# 02员工管理
@login_required
def staffs(request):
    if request.method == "GET":
        form = forms.StaffForm()
        staffs = Staff.objects.all()
        return render(request, 'manage/staffs.html', {
            'form': form,
            'staffs': staffs,
        })
    elif request.method == "POST":
        form_back = forms.StaffForm(request.POST)
        if form_back.is_valid():
            form_back.save()
            return redirect('/manage/staffs')
        else:
            print(form_back.errors.as_data())
            print(form_back.errors.as_json())
            print(form_back.errors.as_text())
            print(form_back.errors.as_ul())
            return HttpResponse(json.dumps({
                'status': 'FAIL',
            }))


# 03餐位管理
@login_required
def tables(request):
    if request.method == "GET":
        print("get")
        form = forms.Staff_TableForm()
        tables = []
        staffs = []
        with connection.cursor() as cursor:
            SELECT_COL = ' distinct {0}_staff_table.ID table_id '
            SELECT_COL += ', {0}_staff_table.name table_name '
            SELECT_COL += ', {0}_staff.ID staff_id '
            SELECT_COL += ', {0}_staff.name staff_name '
            SELECT_COL = SELECT_COL.format('OrderSystem')

            SELECT_FROM = '{0}_staff_table, {0}_staff '
            SELECT_FROM = SELECT_FROM.format('OrderSystem')

            SELECT_WHERE = '{0}_staff.ID = {0}_staff_table.staff_id '
            SELECT_WHERE = SELECT_WHERE.format('OrderSystem')

            SELECT_SQL = f'select {SELECT_COL} from {SELECT_FROM} where {SELECT_WHERE}'
            cursor.execute(SELECT_SQL)

            tables = dictfetchall(cursor)

        with connection.cursor() as cursor:
            cursor.execute(
                'select ID staff_id, name staff_name from OrderSystem_staff;')
            staffs = dictfetchall(cursor)

        print(tables)

        return render(request, 'manage/tables.html', {
            'form': form,
            'tables': tables,
            'staffs': staffs,
        })
    elif request.method == "POST":
        print("post")
        form_back = forms.Staff_TableForm(request.POST)
        if form_back.is_valid():
            form_back.save()
            return redirect('/manage/tables')
        else:
            print(form_back.errors.as_data())
            print(form_back.errors.as_json())
            print(form_back.errors.as_text())
            print(form_back.errors.as_ul())
            return HttpResponse(json.dumps({
                'status': 'FAIL',
            }))


# 04菜品管理
@login_required
def foods(request):
    if request.method == "GET":
        foods = Food.objects.all()
        food_types = Foodtype.objects.all()
        food_form = forms.FoodForm()
        food_type_form = forms.FoodtypeForm()
        return render(request, 'manage/foods.html', {
            'food_form': food_form,
            'food_type_form': food_type_form,
            'foods': foods,
            'food_types': food_types,
        })
    elif request.method == "POST":
        form_food = forms.FoodForm(request.POST)
        form_food_type = forms.FoodtypeForm(request.POST)
        if form_food.is_valid():
            form_food.save()
            return redirect('/manage/foods')
        elif form_food_type.is_valid():
            form_food_type.save()
            return redirect('/manage/foods')
        else:
            return HttpResponse(json.dumps({
                'status': 'FAIL',
            }))


# 05删除菜品
@login_required
def dark(request):
    if request.method == "POST":
        target = request.POST

        table = target['table']
        SQL = ''
        if target['double'] == 'false':
            ID = target['id']
            SQL += f'delete from OrderSystem_{table} where ID={ID}'
        elif target['double'] == 'true':
            foodID_id = target['foodID_id']
            orderID_id = target['orderID_id']
            SQL += f'delete from OrderSystem_{table} where foodID_id={foodID_id} and orderID_id={orderID_id}'

        print('========================================================================')
        print(SQL)
        print('========================================================================')
        try:
            with connection.cursor() as cursor:
                cursor.execute(SQL)
            return HttpResponse(json.dumps({
                'status': 'OK',
            }))
        except:
            return HttpResponse(json.dumps({
                'status': 'FAIL',
            }))


def review_page(request):
    """
    显示评价页面
    """
    return render(request, 'review.html')


def submit_review(request):
    if request.method == 'POST':
        name = request.POST.get('name', '')
        rating = request.POST.get('rating')
        comment = request.POST.get('comment')

        if rating and comment:
            Review.objects.create(
                name=name if name else None,
                rating=int(rating),
                comment=comment
            )
            messages.success(request, "评价提交成功！感谢您的反馈。") # 添加成功消息
            return redirect('review_page') # 使用 name 跳转更规范

    return redirect('review_page')


def get_reviews(request):
    """
    获取评价列表 (AJAX)
    """
    reviews = Review.objects.all().values('name', 'rating', 'comment', 'created_at')
    reviews_list = list(reviews)

    # 格式化日期
    for review in reviews_list:
        review['created_at'] = review['created_at'].strftime('%Y-%m-%d %H:%M')

    return JsonResponse({'reviews': reviews_list})


def review_list(request):
    """
    评价列表页面
    """
    return render(request, 'ReviewList.html')
