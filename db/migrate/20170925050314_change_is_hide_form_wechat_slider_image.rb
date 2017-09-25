class ChangeIsHideFormWechatSliderImage < ActiveRecord::Migration[5.0]
  def change
    change_column_default :wechat_slider_images, :is_hide, :false 
  end
end
