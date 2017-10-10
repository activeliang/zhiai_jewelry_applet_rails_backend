class AdminController < ApplicationController
  # before_action :auth_admin_or_wechat_user
  before_action :admin_required_site_or_wechat
  def recent_login_log
    log = LoginLog.where( "login_at > ?", Date.today - 30).where(is_hide: false)
    users = WechatUser.where(id: log.map{|x| x.wechat_user_id})
    user_hash = Hash.new(0)
    helper_array = []
    log.map{|x| user_hash[x.wechat_user_id] += 1}
    user_hash.each do |k,v|
      if user = users.find_by_id(k)
        helper_array << {id: k, detail: user.slice(:nickname, :avatar_url), times: v}
      end
    end
    render json: helper_array
  end

  def get_user_login_log
    logs = LoginLog.where( wechat_user_id: params[:wechat_user_id])
    detail = WechatUser.find(params[:wechat_user_id])
    render json: {logs: logs.map{|x| { date: x.login_at.strftime("%F"), time: x.login_at.strftime("%r").gsub(/AM|PM|\s/, ''), weekday: render_chinese_weekday(x.login_at.strftime("%A")), time_type: x.login_at.strftime("%p") == "AM" ? "上午" : "下午" } }, detail: detail}
  end

  private

  def render_user_detail(k,v)
      user = WechatUser.find(k)
      return { nickname: user.nickname, avatar: user.avatar_url, times: v }
  end

  def render_chinese_weekday(str)
    if str.present?
      case str
      when "Monday"
        return "星期一"
      when "Tuesday"
        return "星期二"
      when "Wednesday"
        return "星期三"
      when "Thursday"
        return "星期四"
      when "Friday"
        return "星期五"
      when "Saturday"
        return "星期六"
      when "Sunday"
        return "星期日"
      end
    end
  end
end
