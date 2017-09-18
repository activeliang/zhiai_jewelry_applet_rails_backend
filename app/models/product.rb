class Product < ApplicationRecord
  mount_uploader :video, ProductVideoUploader
  serialize :images, JSON

  belongs_to :category
  has_many :product_images, -> { order(weight: 'desc') },
    dependent: :destroy
  has_one :main_product_image, -> { order(weight: 'desc') },
    class_name: :ProductImage

  def main_image
    self.images.split("&").first
  end
end
