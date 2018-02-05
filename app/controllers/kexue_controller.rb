class KexueController < ApplicationController
  before_action :require_item_expired, only: [:get_qr, :show_qr, :show_wingy_qr]
  layout 'kexue'

  def index
  end

  def get_qr
    @record = SsItem.find_by(re_code: params[:re_code])
    if params[:re_code] && @record && @record.qr_code.scan(/#/).empty?
      @re_code = params[:re_code]
    elsif @record.present? && @record.qr_code.scan(/#/).to_a.any?
      redirect_to kexue_show_qr_path(re_code:params[:re_code])
    else
      render '/kexue/none'
    end
  end

  def update_ss_item
    if @record = SsItem.find_by(re_code: params[:wechat][:re_code])
      @record.update wechat: params[:wechat][:wechat_id], is_draw: true, draw_date: Time.now
      unless @record.qr_code.scan(/#/).any?
        @record.update qr_code: (@record.qr_code + "#" + URI.encode(params[:wechat][:wechat_id]))
      end
      redirect_to kexue_show_qr_path(re_code: params[:wechat][:re_code])
    else
      redirect_to root_path, alert: "你的链接出错，请重新获取！"
    end
  end

  def show_qr
    @record = SsItem.find_by(re_code: params[:re_code])
    @qr = @record.shadow_qr_code
      unless @record && @record.wechat.present?
        render 'kexue/none'
      end
      if @record.status == "init"
        @record.update status: 1
      end
  end

  def show_wingy_qr
    @record = SsItem.find_by(re_code: params[:re_code])
    @qr = @record.wingy_qr_code
      unless @record && @record.wechat.present?
        render 'kexue/none'
      end
      if @record.status == "init"
        @record.update status: 1
      end
  end

  private
    def require_item_expired
      @record = SsItem.find_by(re_code: params[:re_code])
      unless current_user && current_user.is_admin
        if @record.present? && @record.expired?
          render "/kexue/none"
        end
      end
    end

end
