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

  scope :ascend, -> { order(weight: "asc") }
  scope :select_index_show, -> { where(index_show: true) }
  scope :ascend_index_weight, -> { order(index_weight: 'asc') }

  # 由微信端新增产品
  def self.create_form_wechat!(params)
    product = self.new title: params[:title],  sub_title: params[:sub_title], category_id: params[:category_id], description: params[:description], weight: params[:weight], price: params[:price], index_show: params[:index_show], is_hide: params[:is_hide], in_stock: params[:in_stock]
    if product.save
      return { status: "ok", id: product.id }
    else
      return { status: "failed", info: product.errors.messages.values.flatten }
    end
  end

  # 根据微信传来的参数更新产品栏位。。。
  def self.update_form_wechat!(params)
    product = self.find(params[:id])
      product.title = params[:title] if params[:title].present?
      product.sub_title = params[:sub_title] if params[:sub_title].present?
      product.description = params[:description] if params[:description].present?
      product.video = params[:video] if params[:video].present?
      product.price = params[:price] if params[:price].present?
      product.in_stock = params[:in_stock] if params[:in_stock].present?
      product.index_show = params[:index_show] if params[:index_show].present?
      product.is_hide = params[:is_hide] if params[:is_hide].present?
      product.weight = params[:weight] if params[:weight].present?
    return product.save ? { status: "ok", id: product.id } : { status: "failed", info: product.errors.messages.values.flatten }
  end

  # 更改is_hide状态
  def change_is_hide_status!
    self.is_hide = !self.is_hide
    self.save
  end

  # 更新in_stock状态
  def change_in_stock_status!
    self.in_stock = !self.in_stock
    self.save
  end

  # 更新index_show状态
  def change_index_show_status!
    self.index_show = !self.index_show
    self.save
  end

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
