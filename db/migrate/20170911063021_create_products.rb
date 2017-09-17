class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.decimal :price, precision: 10, scale: 2
      t.string :title, :sub_title, :video, :images
      t.text :description
      t.integer :weight, :category_id
      t.boolean :in_stock, default: true
      t.boolean :index_show, default: false
      t.boolean :is_hide, default: false
      t.timestamps
    end

    add_index :products, [:category_id]
    add_index :products, [:title]
    add_index :products, [:weight]
  end
end
