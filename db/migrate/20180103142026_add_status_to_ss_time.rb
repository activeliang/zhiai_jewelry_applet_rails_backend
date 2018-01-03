class AddStatusToSsTime < ActiveRecord::Migration[5.0]
  def change
    add_column :ss_items, :status, :integer, default: 0
  end
end
