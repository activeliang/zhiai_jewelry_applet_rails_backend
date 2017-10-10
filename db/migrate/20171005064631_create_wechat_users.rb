class CreateWechatUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_users do |t|
      t.string :nickname, :city, :country, :province, :avatar_url, :session_key, :open_id, :client_token
      t.integer :gender, :user_id
      t.datetime :expired_at
      t.timestamps
    end

    add_index :wechat_users, [:open_id]
    add_index :wechat_users, [:client_token]
  end
end
