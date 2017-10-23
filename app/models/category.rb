class Category < ApplicationRecord
  mount_uploader :image, CategoryImageUploader
  mount_uploader :index_image, HomepageCategoryImageUploader

  validates_presence_of :title, message: "标题不能为空！"
  has_ancestry
  has_many :products, dependent: :destroy

  scope :ascend, -> { order(weight: "asc") }

  # 返回分类树
  def self.render_category_tree
    category_roots = self.includes(:products).roots.ascend
    scroll_a = []
    item_a = []
    tmp = 0
    sum = Hash.new(0)
    category_roots.map{|x| scroll_a <<  ((x.children.count + x.products.count) / 3.000).ceil }
    category_roots.map{|x| item_a << ((x.children.count + x.products.count) / 3.000).ceil * 126 + 88 }
    category_roots.map{|x| sum["item"] += ((x.children.count + x.products.count) / 3.000).ceil; sum["title"] += 1}
    return {sum: sum, item_a: item_a, scroll_detail: scroll_a, test: "test", tree:  category_roots.map{|r| { id: r.id, title: r.title, products: render_products(r), children: render_children(r) }}}
  end

  def update_form_website(params)
    self.image = params[:category][:image] if params[:category][:image].present?
    self.weight = params[:category][:weight] if params[:category][:weight].present?
    self.title = params[:category][:title] if params[:category][:title].present?
    self.index_show = params[:category][:index_show] if params[:category][:index_show].present?
    self.index_image = params[:category][:index_image] if params[:category][:index_image].present?
    self.index_weight = params[:category][:index_weight] if params[:category][:index_weight].present?
    return self.save ? "已更新！" : "操作失败，请联系管理员"
  end

  def update_form_api(params)
    self.title = params[:title] if params[:title].present?
    self.weight = params[:weight] if params[:weight].present?
    self.image = params[:image] if params[:image].present?
    self.ancestry = params[:parent_id] if params[:parent_id].present?
    return self.save ? { status: "ok", id: self.id } : { status: "failed", info: self.errors.messages.values.flatten }
  end

  def change_index_show_status!
    self.index_show = !self.index_show
    self.save
  end

  private

  def self.render_products(root)
    return root.products.map{|p| { id: p.id, title: p.title[0..4] + "...", image: (p.product_images.present? ? p.product_images.shuffle.last.image.thumb.url : "")}}
  end

  def self.render_children(root)
    if root.children.present?
      return root.children.order(weight: 'asc').map{|c| { id: c.id, title: c.title, image: c.image.thumb.url }}
    end
  end

end
