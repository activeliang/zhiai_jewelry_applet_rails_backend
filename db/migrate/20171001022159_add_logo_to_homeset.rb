class AddLogoToHomeset < ActiveRecord::Migration[5.0]
  def change
    add_column :homesets, :logo, :string
  end
end
