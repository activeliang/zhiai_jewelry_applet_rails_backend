class WechatSliderImage < ApplicationRecord
  mount_uploader :image, SliderImageUploader

  def update_column(params)
    self.weight = params[:wechat_silder_image][:weight] if params[:wechat_silder_image][:weight].present?
    self.is_hide = params[:wechat_silder_image][:is_hide] if params[:wechat_silder_image][:is_hide].present?
    self.product_id = params[:wechat_silder_image][:product_id] if params[:wechat_silder_image][:product_id].present?
    return self.save ? "更新成功……" : "更新失败，请联系管理员！"
  end

  def change_is_hide_status!
    self.is_hide = !self.is_hide
    self.save!
  end

end
