class CreateProductImages < ActiveRecord::Migration[5.0]
  def change
    create_table :product_images do |t|
      t.integer :product_id
      t.integer :weight
      t.string :image
      t.timestamps
    end
    add_index :product_images, [:product_id, :weight]
  end
end
