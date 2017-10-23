class ProductImage < ApplicationRecord
  mount_uploader :image, ProductImageUploader
  belongs_to :product


  def self.add_image(id, path)
    img = self.new
    img.image = open(path, "r")
    img.product_id
    img.save!
    return img.id
  end

end
