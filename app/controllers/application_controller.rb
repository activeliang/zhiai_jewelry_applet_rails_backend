class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

  def admin_required
    if logged_in?
      if !current_user.admin?
        redirect_to "/", alert: "您不是管理员，请以管理员账号登入！"
      end
    else
      redirect_to new_session_path, alert: "请先登入！"
    end
  end

  def auth_user
    unless logged_in?
      flash[:notice] = "请登录~"
      redirect_to new_session_path
    end
  end
end
