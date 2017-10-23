class AddIndexWeightToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :index_weight, :integer
  end
end
