class CategoriesController < ApplicationController
  before_action :find_category, only: [:update_column]
  def index
    @category_roots = Category.includes(:products).all.roots
    @category = Category.new
    respond_to do |format|
      format.html
      format.json{

        scroll_a = []
        tmp = 0
        @category_roots.map{|x| scroll_a << tmp += (x.children.count / 3.000).ceil * 70 + 30  }

        render :json => { scroll_detail: scroll_a, test: "test", tree:  @category_roots.map{|r| { id: r.id, title: r.title, products: render_products(r), children: render_children(r) }}}
      }
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "新增成功！"
    else
      render :back
    end
  end

  def show
    @category = Category.includes(:products).find(params[:id])
    respond_to do |format|
      format.html
      format.json{
        render :json => @category.products.map{|p| {id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, image: p.images.split("&").first}}
      }
    end
  end

  # 更新数据
  def update_column
    @category.update_attribute :title, params[:category][:title] if params[:category][:title]
    @category.update_attribute :weight, params[:category][:weight] if params[:category][:weight]
    redirect_to :back, notice: "已更新！"
  end





  # 私有方法
  private
  def category_params
    params.require(:category).permit(:title, :weight, :ancestry)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def render_children(root)
    if root.children.present?
      return root.children.map{|c| { id: c.id, title: c.title, image: c.image }}
    end
  end

  def render_products(root)
    return root.products.map{|p| { id: p.id, title: p.title, image: p.main_image}}
  end
end
