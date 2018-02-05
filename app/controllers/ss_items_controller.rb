class SsItemsController < ApplicationController
  before_action :auth_admin_or_wechat_user


  def index
    @ss_items = SsItem.where(ss_service_id: params[:ss_service_id]).order("is_send asc")
  end

  def change_send_status
    @ss_item= SsItem.find(params[:id])
    if @ss_item.is_send
      @ss_item.update is_send: false
    else
      @ss_item.update is_send: true
    end
    redirect_to ss_service_ss_items_path(@ss_item.ss_service_id), notice: "更改成功~"
  end

  def init_draw_time
    @ss_item = SsItem.find(params[:id])
    @ss_item.update draw_date: nil
    redirect_to ss_service_ss_items_path(@ss_item.ss_service_id), notice: "更改成功~"
  end

  def admin_show_qr
    @ss_item = SsItem.find(params[:id])
    @qr = @ss_item.shadow_qr_code
  end
end
