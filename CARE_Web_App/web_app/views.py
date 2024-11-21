from django.shortcuts import render, redirect

from .forms import CreateUserForm, LoginForm

from django.contrib.auth.models import auth
from django.contrib.auth import authenticate

# Home Page
def home(request):

    return render(request, 'web_app/index.html')

# Register a user
def register(request):
    form = CreateUserForm()

    if request.method == "POST":

        form = CreateUserForm(request.POST)

        if form.is_valid():

            form.save()

            # return redirect('')

    context = {'form': form}

    return render(request, 'web_app/register.html', context = context)

# Login a user
def my_login(request):

    form = LoginForm()

    if request.method == "POST":

        form = LoginForm(request, data=request.POST)

        if form.is_valid():

            username = request.POST.get('username')
            password = request.POST.get('password')

            user = authenticate(request, username=username, password=password)

            if user is not None:

                auth.login(request, user)

                return redirect('my-login')

    context = {'form2':form}

    return render(request, 'web_app/my-login.html', context=context)


