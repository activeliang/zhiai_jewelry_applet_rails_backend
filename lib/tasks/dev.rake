namespace :dev do

  task :fake => :environment do
    roots = []
    children = []
    category_tem = ["http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-4-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-3-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-5-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg.jpeg"]
    product_tem = ["http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-1-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-2-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-6-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-3-.jpeg", "http://olmrxx9ks.bkt.clouddn.com/2017-09-22-timg%20-5-.jpeg"]

    3.times do
      roots << Category.create!( title: Faker::Name.first_name,
                                 weight: 1
                                )
    end


    22.times do
      roots << Category.create!( title: Faker::Name.first_name,
                                 weight: Faker::Number.between(2, 20)
                                )
    end


    random_2 = roots[1..3]


      3.times do
        children << Category.create!( title: Faker::Lorem.word,
                          weight: Faker::Number.between(1, 140),
                          remote_image_url: category_tem.shuffle.first,
                          ancestry: roots.first.id
                          )
      end




    random_2.each do |r|
      6.times do
        Category.create!( title: Faker::Lorem.word,
                          weight: Faker::Number.between(1, 20),
                          remote_image_url: category_tem.shuffle.first,
                          ancestry: roots[0..2].shuffle.first.id
                          )
      end
    end

    3.times do
       p_1 = Product.create!( :title => Faker::Lorem.word,
                                sub_title: Faker::Lorem.sentence,
                                description: Faker::Lorem.paragraph,
                                remote_video_url: "http://ow9r8dc0w.bkt.clouddn.com/Apple%20Official%20iPhone%208%20Trailer%202017.mp4",
                                price: Faker::Number.decimal(2),
                                weight: Faker::Number.between(1, 1500),
                                in_stock: Faker::Boolean.boolean(0.93),
                                index_show: Faker::Boolean.boolean(0.024),
                                is_hide: Faker::Boolean.boolean(0.93),
                                category_id: roots.first.id
                               )
                               product_tem.map{|a| p_1.product_images.create remote_image_url: a }
    end

    22.times do
       p_2 = Product.create!( :title => Faker::Lorem.word,
                                 sub_title: Faker::Lorem.sentence,
                                 description: Faker::Lorem.paragraph,
                                 remote_video_url: "http://ow9r8dc0w.bkt.clouddn.com/Apple%20Official%20iPhone%208%20Trailer%202017.mp4",
                                 price: Faker::Number.decimal(2),
                                 weight: Faker::Number.between(1, 1500),
                                 in_stock: Faker::Boolean.boolean(0.93),
                                 index_show: Faker::Boolean.boolean(0.024),
                                 is_hide: Faker::Boolean.boolean(0.93),
                                 category_id: children[0..2].shuffle.first.id
                                )
                                product_tem.map{|a| p_2.product_images.create remote_image_url: a }
    end

  end

end
