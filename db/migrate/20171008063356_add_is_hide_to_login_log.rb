class AddIsHideToLoginLog < ActiveRecord::Migration[5.0]
  def change
    add_column :login_logs, :is_hide, :boolean, default: false
  end
end
