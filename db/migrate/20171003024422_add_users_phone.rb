class AddUsersPhone < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :phone, :string
    remove_index :users, [:email]
    add_index :users, [:phone]
    change_column :users, :email, :string, null: true
  end
end
