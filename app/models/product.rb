class Product < ApplicationRecord
  mount_uploader :video, ProductVideoUploader
  serialize :images, JSON

  belongs_to :category
  has_many :product_images, -> { order(weight: 'asc') },
    dependent: :destroy
  has_one :main_product_image, -> { order(weight: 'asc') },
    class_name: :ProductImage

  def main_image
    if self.product_images.present?
      self.product_images.order(weight: 'asc').shuffle.last.image.url
    end
  end
end
