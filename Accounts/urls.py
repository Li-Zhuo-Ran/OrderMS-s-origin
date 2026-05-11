from django.urls import path
from . import views

# 用户模块子路由
urlpatterns = [
    path('signin/', views.signin),  # 登录
    path('order/signin/', views.order_signin),  # 点餐登录
    path('order/login/', views.order_signin),  # 点餐登录别名
    path('signup/', views.signup),  # 注册
    path('signout/', views.signout),  # 退出
    path('accounts/signin/', views.signin),  # 登录兼容路径
    path('accounts/signup/', views.signup),  # 注册兼容路径
    path('accounts/signout/', views.signout),  # 退出兼容路径
]
