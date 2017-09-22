namespace :dev do

  task :fake => :environment do
    roots = []
    children = []


    30.times do
      roots << Category.create!( title: Faker::Name.first_name,
                                 weight: Faker::Number.between(1, 20)
                                )
    end

    170.times do
      children << Category.create!( title: Faker::Lorem.word,
                        weight: Faker::Number.between(1, 140),
                        image: "https://placehold.it/50x30.jpg/2dbe60/333?text=Some%20Custom%20Text",
                        ancestry: roots.sample.id
                        )
    end

    random = roots.shuffle[0..14]
    45.times do
      tem = ["https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text"]
      Product.create!( :title => Faker::Lorem.word,
                                sub_title: Faker::Lorem.sentence,
                                description: Faker::Lorem.paragraph,
                                video: "http://ow9r8dc0w.bkt.clouddn.com/WeChatSight210.mp4",
                                price: Faker::Number.decimal(2),
                                weight: Faker::Number.between(1, 1500),
                                # images: tem.join("&"),
                                in_stock: Faker::Boolean.boolean(0.93),
                                index_show: Faker::Boolean.boolean(0.024),
                                is_hide: Faker::Boolean.boolean(0.93),
                                category_id: random.sample.id
                               )
    end

    1700.times do
      tem = ["https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text","https://placehold.it/423x468.jpg/2dbe60/333?text=Some%20Custom%20Text"]
       Product.create!( :title => Faker::Lorem.word,
                                 sub_title: Faker::Lorem.sentence,
                                 description: Faker::Lorem.paragraph,
                                 video: "http://ow9r8dc0w.bkt.clouddn.com/WeChatSight210.mp4",
                                 price: Faker::Number.decimal(2),
                                 weight: Faker::Number.between(1, 1500),
                                #  images: tem.join("&"),
                                 in_stock: Faker::Boolean.boolean(0.93),
                                 index_show: Faker::Boolean.boolean(0.024),
                                 is_hide: Faker::Boolean.boolean(0.93),
                                 category_id: children.sample.id
                                )
    end

  end

end
