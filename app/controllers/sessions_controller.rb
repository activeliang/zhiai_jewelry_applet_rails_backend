class SessionsController < ApplicationController
  protect_from_forgery except: [:wechat_login, :admin_required]

  def new
    render layout: 'backgroundstar'
  end

  def create
    if user = login(params[:phone], params[:password])
      flash[:notice] = "登陆成功"
      redirect_back_or_to homeset_index_path
    else
      flash[:notice] = "手机号或者密码不正确"
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "退出成功"
    redirect_to root_path
  end

  def wechat_login
    if params[:client_token]
      render json: WechatUser.login_form_wechat_client_token(params)
    elsif params[:code]
       render json: WechatUser.login_form_wechat_login_code(params)
    end
  end

  # 小程序端管理权限验证
  def admin_required
    if (user = login(params[:phone], params[:password])) && user.admin? && current_wechat_user
      current_wechat_user.update!(user_id: user.id, expired_at: Time.now + 259200)
      render :json => { status: "ok", userType: "admin", }
    else
      render :json => { status: "failed", userType: "general", info: "验证失败，您目前不是管理员！" }
    end
  end
end
