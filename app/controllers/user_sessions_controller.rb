class UserSessionsController < ApplicationController
  respond_to :html

  def new
    # На странице логина нужно отобразить форму регистрации
    respond_with @user = User.new
  end

  def create
   if @user = login(params[:email], params[:password], params[:remember_me])
      redirect_back_or_to(root_path)
    else
      flash.now[:danger] = t('.login_failed_message')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
