class CreateHomesets < ActiveRecord::Migration[5.0]
  def change
    create_table :homesets do |t|
      t.string :banner, :shop_title, :open_time, :address, :phone_no, :shop_video
      t.timestamps
    end
  end
end
