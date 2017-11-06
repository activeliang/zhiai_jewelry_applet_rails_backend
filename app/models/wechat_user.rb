class WechatUser < ApplicationRecord
  belongs_to :user, optional: true
  has_many :login_logs, dependent: :destroy
  has_many :collects, dependent: :destroy

  validates_presence_of :client_token, message: "用户client_token不能为空！"

  # 通过client_token登入
  def self.login_form_wechat_client_token(params)
    if wechat_user = self.find_by_client_token(params[:client_token])
      type_admin = wechat_user.user && wechat_user.user.is_admin && wechat_user.expired_at > Time.now
      # 更新登录记录
      if (last_log = LoginLog.render_wechat_user_last_log(wechat_user.id)) && last_log.login_at > Time.now - 900
        last_log.update_column :login_at, Time.now
      else
        LoginLog.create wechat_user_id: wechat_user.id, login_at: Time.now
      end
      return { status: "ok", userToken: wechat_user.client_token, userType: type_admin ? "admin" : "general"}
    else
      return { status: "failed", info: "need code and user detail."}
    end
  end

  # 通过wechat_login_code登入
  def self.login_form_wechat_login_code(params)
    respsive = JSON.parse RestClient.get("https://api.weixin.qq.com/sns/jscode2session?appid=" + Figaro.env.appid + "&secret=" + Figaro.env.appsecret + "&js_code=" + params[:code] + "&grant_type=authorization_code").body
    if respsive.present?
      client_token = SecureRandom.hex(16)
      wx_user = self.find_by_open_id(respsive["openid"]) || self.new
      wx_user.open_id = respsive["openid"]
      wx_user.session_key = respsive["session_key"]
      wx_user.client_token = client_token

      if params[:user_info].present?
        wx_user.nickname = params[:user_info][:nickName]
        wx_user.gender = params[:user_info][:gender]
        wx_user.city = params[:user_info][:city]
        wx_user.province = params[:user_info][:province]
        wx_user.country = params[:user_info][:country]
        wx_user.avatar_url = params[:user_info][:avatarUrl]
      end
      wx_user.save

      # 更新登入记录
      last_log = LoginLog.render_wechat_user_last_log(wx_user.id)
      if last_log.present? && last_log.login_at > Time.now - 900
        last_log.login_at = Time.now
        last_log.save
      else
        LoginLog.create wechat_user_id: wx_user.id, login_at: Time.now
      end
      return { status: "ok", userToken: wx_user.client_token, userType: "general" }
    end
  end

  def collection_do(params)
    if collect = self.collects.find_by_product_id(params[:product_id]) || self.collects.build
      tag = collect.new_record?
      collect.product_id = params[:product_id]
      collect.product_name = params[:product_name]
      collect.image_url = params[:product_img]
      collect.save
    end
    return { status: "ok", info:  tag ? "已收藏！" : "已存在！" }
  end

end
