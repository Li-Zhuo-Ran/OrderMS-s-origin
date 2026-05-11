from django.urls import path, re_path
from . import views


# 订单子路由
urlpatterns = [
    path('', views.home, name='home'),
    path('order', views.OrderHome, name='OrderHome'),
    path('order/', views.OrderHome),
    path('check', views.CheckUnpaidOrder),
    path('order/check', views.CheckUnpaidOrder),
    path('checkout', views.CheckOut),
    path('order/checkout', views.CheckOut),
    re_path(r'order/q(?P<order_id>[\d]+)', views.QueryOrder),
    re_path(r'q(?P<order_id>[\d]+)', views.QueryOrder),
    path('cook/', views.cook, name='cook'),
    path('cook', views.cook),
    path('delive_food/', views.delive_food, name='delive_food'),
    path('delive_food', views.delive_food),
    path('food_supplier/', views.food_supplier, name='food_supplier'),
    path('food_supplier', views.food_supplier),
    path('manage/orders', views.orders, name='orders'),
    path('manage/staffs', views.staffs, name='staffs'),
    path('manage/tables', views.tables, name='tables'),
    path('manage/foods', views.foods, name='foods'),
    path('manage/dark', views.dark, name='dark'),
    path('manage/serving_table_list', views.getServingTableList, name='getServingTableList'),
    path('manage/serving_order_item_list', views.getOrderItemList, name='getOrderItemList'),
    path('manage/set_staff_charge_table', views.set_staff_charge_table, name='set_staff_charge_table'),
    path('manage/staff_charge_table', views.set_staff_charge_table),
    path('manage/delive_food', views.delive_food),
    path('manage/', views.manage, name='manage'),
    path('review/', views.review_page, name='review_page'),          # 对应 review.html 页面
    path('review/submit/', views.submit_review, name='submit_review'), # 对应表单提交 action
    path('review/list/', views.get_reviews, name='get_reviews'),       # 对应 AJAX 获取列表
    path('review/list/page/', views.review_list, name='review_list'),  # 评价列表页面
]



