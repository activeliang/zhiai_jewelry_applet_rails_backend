class CreateWechatSliderImages < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_slider_images do |t|
      t.string :image
      t.integer :weight
      t.boolean :is_hide

      t.timestamps
    end
    add_index :wechat_slider_images, :weight
  end
end
