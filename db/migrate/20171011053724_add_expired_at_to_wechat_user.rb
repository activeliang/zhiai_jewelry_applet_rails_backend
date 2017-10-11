class AddExpiredAtToWechatUser < ActiveRecord::Migration[5.0]
  def change
    add_column :wechat_users, :expired_at, :datetime
  end
end
