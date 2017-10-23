class UsersController < ApplicationController

  def new
    @user = User.new
    render layout: 'backgroundstar'
  end

  def create
    @user =User.new(user_params)
    if @user.save && login(params[:user][:phone], params[:user][:password], true)
      flash[:notice] = '注册成功～已登录！'
      redirect_to products_path
    else
      @user.errors
      render action: :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :phone, :token)
  end
  
end
