class AddProductIdToWechatSliderImage < ActiveRecord::Migration[5.0]
  def change
    add_column :wechat_slider_images, :product_id, :integer
  end
end
