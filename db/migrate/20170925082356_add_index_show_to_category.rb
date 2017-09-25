class AddIndexShowToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :index_show, :boolean, default: false
  end
end
