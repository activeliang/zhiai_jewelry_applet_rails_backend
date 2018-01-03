class CreateSsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :ss_items do |t|
      t.integer :ss_service_id
      t.string :port, :password, :qr_code, :wechat, :remarks, :re_code
      t.boolean :is_draw, default: false
      t.boolean :is_send, default: false
      t.datetime :draw_date
      t.timestamps
    end
  end
end
