# OrderMS-s-origin

## 技术栈

- 后端：Django（`OrderMS` + `OrderSystem`）
- 前端：Vue.js（后厨页面 `templates/FoodSupplier.html` + `static/js/vue/food-supplier-app.js`）

## 快速启动

1. 安装依赖：

```bash
pip install -r requirements.txt
```

2. 配置数据库环境变量（默认 MySQL）：

```bash
export DB_NAME=db_order
export DB_USER=root
export DB_PASSWORD=1314
export DB_HOST=127.0.0.1
export DB_PORT=3306
```

3. 迁移数据库并启动：

```bash
python manage.py migrate
python manage.py runserver
```

4. 打开后厨页面：

- `http://127.0.0.1:8000/food_supplier/`

## 后厨订单状态流转

`OrderItem.status` 使用如下状态：

- `0 待接单`
- `1 已接单`
- `2 制作中`
- `3 待上菜`
- `4 已上菜`
- `5 已取消`

合法流转：

- 待接单 -> 已接单 / 已取消
- 已接单 -> 制作中 / 已取消
- 制作中 -> 待上菜 / 已取消
- 待上菜 -> 已上菜
- 已上菜、已取消不可继续流转
