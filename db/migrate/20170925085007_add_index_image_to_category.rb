class AddIndexImageToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :index_image, :string
  end
end
