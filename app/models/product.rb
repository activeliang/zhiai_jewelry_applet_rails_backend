class Product < ApplicationRecord
  mount_uploader :video, ProductVideoUploader
  serialize :images, JSON

  validates_presence_of :category_id, message: "所属分类不能为空"
  validates_presence_of :title, message: "商品名称不能为空"
  validates_presence_of :sub_title, message: "副标题不能为空"
  validates_presence_of :price, message: "价格不能为空"
  validates_presence_of :description, message: "商品详情不能为空"


  belongs_to :category
  has_many :product_images, -> { order(weight: 'asc') },
    dependent: :destroy
  has_one :main_product_image, -> { order(weight: 'asc') },
    class_name: :ProductImage

  def main_image_thumb
    if self.product_images.present?
      self.product_images.order(weight: 'asc').shuffle.last.image.thumb.url
    end
  end
  def main_image_small
    if self.product_images.present?
      self.product_images.order(weight: 'asc').shuffle.last.image.small.url
    end
  end
  def main_image_medium
    if self.product_images.present?
      self.product_images.order(weight: 'asc').shuffle.last.image.medium.url
    end
  end
end
