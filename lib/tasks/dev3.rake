namespace :dev3 do

jewelry_video_url = "http://hongliang.fun/Apple%20Official%20iPhone%208%20Trailer%202017.mp4"
  task :fake => :environment do

    # 13次为分类增加产品，每个分类增加6个产品。
  13.times do |index|
    # 产品1
    product_1_img = ["http://hongliang.fun/2017-10-14-031414.jpg","http://hongliang.fun/2017-10-14-031649.jpg", "http://hongliang.fun/2017-10-14-031833.jpg", "http://hongliang.fun/2017-10-14-031955.jpg"]
    product_1 = Product.new(
                title: "皇后系列至爱闪耀吊坠",
                sub_title: "MY QUEEN王后专柜同款 金18K钻石吊坠 钻石项链女 结婚礼物 18K白 16分 H/SI/G 赠18k链",
                description: "简洁、经典的设计，将钻石和光彩与K金的质感完美结合，主石与配钻相互辉映，欧洲独特的镶嵌工艺，灵动活跃，低调又不失奢华，百搭的款式令你不论在任何场合佩戴都可以散发出无尽魅力。",
                price: 7720,
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.9)
                )
    product_1.save!
    product_1_img.each do |img|
      product_1.product_images.create remote_image_url: img
    end
    # 产品2
    product_2_img = ["http://hongliang.fun/2017-10-14-033303.jpg","http://hongliang.fun/2017-10-14-033341.jpg","http://hongliang.fun/2017-10-14-033422.jpg","http://hongliang.fun/2017-10-14-033454.jpg"]
    product_2 = Product.new(
                title: "悦动精灵",
                sub_title: "悦动精灵 金18K钻石吊坠女 个性礼物 女士项链 生日礼物 18K白吊坠 +同色银链",
                description: "以丘比特金箭为灵感，融入了坠入爱河的幸福感觉，中间璀璨钻石寓意爱神之箭，圆弧外形象征圆满爱情。",
                price: "999",
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.90)
                )
    product_2.save!
    product_2_img.each do |img|
      product_2.product_images.create remote_image_url: img
    end

    # 产品3
    product_3_img = ["http://hongliang.fun/2017-10-14-033929.jpg","http://hongliang.fun/2017-10-14-074222.jpg","http://hongliang.fun/2017-10-14-074251.jpg","http://hongliang.fun/2017-10-14-074338.jpg"]
    product_3 = Product.new(
                title: "QUEEN款耳坠女",
                sub_title: "QUEEN款耳坠女 专柜同款耳饰 白18K金 镶嵌钻石耳钉珠宝 26分/I-J色",
                description: "简洁、经典的设计，将钻石的光彩和K金的质感完全结合，主石与副石的相互辉映，欧洲独特的镶嵌工艺，灵动活跃，低调而又不失奢华，百搭的款式令你不论在特任场合都有散发出无尽魅力。",
                price: "9650",
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.90)
                )
    product_3.save!
    product_3_img.each do |img|
      product_3.product_images.create remote_image_url: img
    end

    # 产品4
    product_4_img = ["http://hongliang.fun/2017-10-14-034637.jpg","http://hongliang.fun/2017-10-14-034713.jpg","http://hongliang.fun/2017-10-14-034734.jpg","http://hongliang.fun/2017-10-14-034801.jpg"]
    product_4 = Product.new(
                title: "非你莫属女士项链",
                sub_title: "专柜同款金18K钻石吊坠女 唐嫣同款项坠 非你莫属女士项链 礼物 18K白吊坠+银链",
                description: "简洁、经典的设计，将钻石的光彩和K金的质感完全结合，主石与副石的相互辉映，欧洲独特的镶嵌工艺，灵动活跃，低调而又不失奢华，百搭的款式令你不论在特任场合都有散发出无尽魅力。",
                price: "1990",
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.90)
                )
    product_4.save!
    product_4_img.each do |img|
      product_4.product_images.create remote_image_url: img
    end

    # 产品5
    product_5_img = ["http://hongliang.fun/2017-10-14-035407.jpg","http://hongliang.fun/2017-10-14-035431.jpg","http://hongliang.fun/2017-10-14-035459.jpg","http://hongliang.fun/2017-10-14-035528.jpg"]
    product_5 = Product.new(
                title: "星月童话钻石链牌女",
                sub_title: "钻石吊坠女 星月童话钻石链牌女 项链女 情人节礼物（含链） 18K红",
                description: "简洁、经典的设计，将钻石的光彩和K金的质感完全结合，主石与副石的相互辉映，欧洲独特的镶嵌工艺，灵动活跃，低调而又不失奢华，百搭的款式令你不论在特任场合都有散发出无尽魅力。",
                price: "1548",
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.90)
                )
    product_5.save!
    product_5_img.each do |img|
      product_5.product_images.create remote_image_url: img
    end

    # 产品6
    product_6_img = ["http://hongliang.fun/2017-10-14-035714.jpg","http://hongliang.fun/2017-10-14-035737.jpg","http://hongliang.fun/2017-10-14-035806.jpg","http://hongliang.fun/2017-10-14-035843.jpg"]
    product_6 = Product.new(
                title: "ShootingStar梦想之星钻石吊坠女",
                sub_title: "ShootingStar梦想之星钻石吊坠女 专柜同款 金18K项链 黄18K金吊坠+赠银链",
                description: "简洁、经典的设计，将钻石的光彩和K金的质感完全结合，主石与副石的相互辉映，欧洲独特的镶嵌工艺，灵动活跃，低调而又不失奢华，百搭的款式令你不论在特任场合都有散发出无尽魅力。",
                price: "2030",
                remote_video_url: jewelry_video_url,
                weight: Faker::Number.between(2, 20),
                category_id: index + 1,
                index_show: Faker::Boolean.boolean(0.90)
                )
    product_6.save!
    product_6_img.each do |img|
      product_6.product_images.create remote_image_url: img
    end

    # 增加一个分类
    category = Category.new(
              title: Faker::Lorem.word,
              weight: Faker::Number.between(2, 20),
              remote_image_url: (product_1_img + product_2_img + product_3_img + product_4_img + product_5_img + product_6_img).shuffle.first
              )
    category.save!

  end
  end
end
