from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth import login, logout


# 01注册
def signup(request):
    # 注册页面
    if request.method == "GET":
        form = UserCreationForm()
        return render(request, 'signup.html', {'form': form})
    # 注册请求
    elif request.method == "POST":
        return_form = UserCreationForm(request.POST)
        if return_form.is_valid():
            user = return_form.save()
            login(request, user)
            return redirect('/manage/')
        else:
            form = UserCreationForm()
            return render(request, 'signup.html', {
                'form': form,
            })


# 登录
def signin(request):
    form = AuthenticationForm()
    if request.method == "POST":
        return_form = AuthenticationForm(data=request.POST)
        print(return_form)
        if return_form.is_valid():
            user = return_form.get_user()
            login(request, user)
            next_url = request.POST.get('next') or '/'
            return redirect(next_url)

    next = request.GET.get('next')
    return render(request, 'signin.html', {
        'form': form,
        'next': next,
    })


# 点餐登录页（使用与标准登录相同界面）
def order_signin(request):
    form = AuthenticationForm()
    if request.method == "POST":
        return_form = AuthenticationForm(data=request.POST)
        if return_form.is_valid():
            user = return_form.get_user()
            login(request, user)
            next_url = request.POST.get('next') or '/order'
            return redirect(next_url)
        form = return_form

    next_url = request.GET.get('next') or '/order'
    return render(request, 'signin.html', {
        'form': form,
        'next': next_url,
    })


# 退出登录
def signout(request):
    if request.method == "POST":
        logout(request)
    return redirect('/')
