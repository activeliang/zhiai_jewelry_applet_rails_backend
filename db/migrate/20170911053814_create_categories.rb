class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :weight
      t.string :ancestry, :image
      t.timestamps
    end
    add_index :categories, :ancestry
  end
end
