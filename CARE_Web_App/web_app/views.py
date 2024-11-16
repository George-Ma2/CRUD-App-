from django.shortcuts import render, redirect

from .forms import CreateUserForm, LoginForm

# Home Page
def home(request):

    return render(request, 'web_app/index.html')

# Register
def register(request):
    form = CreateUserForm()

    if request.method == "POST":

        form = CreateUserForm(request.POST)

        if form.is_valid():

            form.save()

            # return redirect('')

