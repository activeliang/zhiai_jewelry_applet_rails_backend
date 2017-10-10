namespace :dev2 do

  task :fake => :environment do
    10.times do
      user = WechatUser.new(
                          :nickname => Faker::Name.first_name,
                          :city => Faker::Name.first_name,
                          :country => Faker::Name.first_name,
                          :province => Faker::Name.first_name,
                          :avatar_url => "http://olmrxx9ks.bkt.clouddn.com/2017-09-28-035300.jpg",
                          :gender => Faker::Number.between(0, 2),
                          :client_token => SecureRandom.hex(16)
                        )
      user.save!
    end

    30.times do
      logs = LoginLog.new(
                          :wechat_user_id => Faker::Number.between(34, 50),
                          :login_at => Time.now
                        )
      logs.save!
    end

  end

end
