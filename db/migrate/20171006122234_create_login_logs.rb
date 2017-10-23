class CreateLoginLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :login_logs do |t|
      t.integer :wechat_user_id
      t.datetime :login_at
      t.timestamps
    end
  end
end
