class LoginLog < ApplicationRecord
  belongs_to :wechat_user

  # 返回最后30天登入记录
  def self.render_recent_login_log
    log = self.where( "login_at > ?", Date.today - 30).where(is_hide: false).order(updated_at: "desc")
    users = WechatUser.where(id: log.map{|x| x.wechat_user_id} )
    user_hash = Hash.new(0)
    helper_array = []
    log.map{ |x| user_hash[x.wechat_user_id] += 1 }
    user_hash.each do |k,v|
      if user = users.find_by_id(k)
        helper_array << { id: k, detail: user.slice(:nickname, :avatar_url), times: v }
      end
    end
    return helper_array
  end

  # 返回某个用户的登入记录
  def self.render_wechat_user_login_log(user_id)
    logs = self.where( wechat_user_id: user_id).order(updated_at: "desc")
    detail = WechatUser.find(user_id)
    return {logs: logs.map{|x| { date: x.login_at.strftime("%F"), time: x.login_at.strftime("%r").gsub(/AM|PM|\s/, ''),
       weekday: render_chinese_weekday(x.login_at.strftime("%A")), time_type: x.login_at.strftime("%p") == "AM" ? "上午" : "下午" } }, detail: detail}
  end

  def self.render_wechat_user_last_log(user_id)
    self.where(wechat_user_id: user_id).order(id: 'desc').first
  end

  private

  def self.render_chinese_weekday(str)
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
