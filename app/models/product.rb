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


  # 返回搜索结果json
  def render_search_result(product)
    return  products.map{|p| { id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, image: p.main_image_thumb}}, paginate: { current_page: products.current_page, previous_page: products.previous_page, next_page: products.next_page, total_page: products.total_pages}
  end

  # 由微信端新增产品
  def create_form_wechat!(params)
    product = self.new title: params[:title],  sub_title: params[:sub_title], category_id: params[:category_id], description: params[:description], weight: params[:weight], price: params[:price], index_show: params[:index_show], is_hide: params[:is_hide], in_stock: params[:in_stock]
    if product.save
      return { status: "ok", id: product.id }
    else
      return { status: "failed", info: product.errors.messages.values.flatten }
    end
  end

  # 根据微信传来的参数更新产品栏位。。。
  def update_form_wechat!(params)
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
    if product.save
      return { status: "ok", id: product.id }
    else
      return { status: "failed", info: product.errors.messages.values.flatten }
    end
  end

  # 更改is_hide状态
  def change_is_hide_status!(id)
    product = self.find(id)
    product.is_hide = !prouct.is_hide
    product.save
  end

  # 更新in_stock状态
  def change_in_stock_status!(id)
    product = self.find(id)
    product.in_stock = !prouct.in_stock
    product.save
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
