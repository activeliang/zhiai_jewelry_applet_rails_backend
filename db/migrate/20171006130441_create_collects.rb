class CreateCollects < ActiveRecord::Migration[5.0]
  def change
    create_table :collects do |t|
      t.integer :product_id, :wechat_user_id
      t.string :image_url, :product_name
      t.boolean :is_exist, default: true
      t.timestamps
    end
  end
end
