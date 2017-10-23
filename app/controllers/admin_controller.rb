class AdminController < ApplicationController
  before_action :auth_admin_or_wechat_user
  # before_action :admin_required_site_or_wechat
  def recent_login_log
    render json: LoginLog.render_recent_login_log
  end

  def get_user_login_log
    render json: LoginLog.render_wechat_user_login_log(params[:wechat_user_id])
  end

end
