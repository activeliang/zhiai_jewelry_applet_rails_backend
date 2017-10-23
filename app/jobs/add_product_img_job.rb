class AddProductImgJob < ApplicationJob
  queue_as :default

  def perform(id, path)
    # product = Product.find(id)
    Rails.logger.info "测试测试测试测试测测试！！！！！！！"
    # binding.pry
    # img_file = File.open(path, "r")
    # img = product.product_images.create! weight: 40
    # product.save!
    img = ProductImage.add_image(id, path)
    # binding.pry

    Rails.logger.info "这是生成的图片的ID：#{img}"
    Rails.logger.info "商品【#{product.title}】已更新图片"
  end
end
