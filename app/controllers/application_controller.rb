class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

  # 网站：验证管理员
  # def admin_required
  #   if current_user
  #     if !current_user.admin?
  #       redirect_to "/", alert: "您不是管理员，请以管理员账号登入！"
  #     end
  #   else
  #     redirect_to new_session_path, alert: "请先登入！"
  #   end
  # end

  # 网站：验证登入
  # def auth_user
  #   unless logged_in?
  #     flash[:notice] = "请先登入~"
  #     redirect_to new_session_path
  #   end
  # end

  # 网站：管理员； 小程序：普通用户
  def auth_admin_or_wechat_user
    unless current_wechat_user || current_user && current_user.admin?
      if request.headers['Authorization']
        return render json: { status: "failed", info: "权限验证错误！,请检查是否已经登入！" }
      else
        redirect_to new_session_path, notice: "请先以管理员账号登陆~！"
      end
    end
  end

  # 网站：管理员；小程序: 管理员
  def admin_required_site_or_wechat
    unless current_wechat_user_is_admin? || currert_user_is_admin?
      if request.headers['Authorization']
        return render json: { status: "failed", info: "权限验证错误！,请检查是否已经登入(管理员)！" }
      else
        redirect_to new_session_path, notice: "请先以管理员账号登陆~！"
      end
    end
  end

  def current_wechat_user
    WechatUser.find_by_client_token(request.headers['Authorization'])
  end

  private

  def current_wechat_user_is_admin?
    if current_wechat_user
      if current_wechat_user.user && current_wechat_user.user.admin?
        return true
      end
    end
  end

  def currert_user_is_admin?
    if current_user && current_user.admin?
      return true
    end
  end
end
