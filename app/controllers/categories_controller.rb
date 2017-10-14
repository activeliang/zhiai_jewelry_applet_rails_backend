class CategoriesController < ApplicationController
  before_action :auth_admin_or_wechat_user
  # before_action :admin_required_site_or_wechat
  protect_from_forgery except: [:create_form_api, :update_form_api, :update_image_form_api]
  before_action :find_category, only: [:update_column, :destroy, :index_show, :index_hide, :delete_category]

  def index
    @category_roots = Category.includes(:products).roots.order(weight: 'asc')
    @category = Category.new
    respond_to do |format|
      format.html{
        @index_show_category = Category.where(index_show: true).order(index_weight: 'asc')
      }
      format.json{
        scroll_a = []
        item_a = []
        tmp = 0
        sum = Hash.new(0)
        # binding.pry
        @category_roots.map{|x| scroll_a <<  ((x.children.count + x.products.count) / 3.000).ceil }
        @category_roots.map{|x| item_a << ((x.children.count + x.products.count) / 3.000).ceil * 126 + 88 }
        @category_roots.map{|x| sum["item"] += ((x.children.count + x.products.count) / 3.000).ceil; sum["title"] += 1}
        render :json => {sum: sum, item_a: item_a, scroll_detail: scroll_a, test: "test", tree:  @category_roots.map{|r| { id: r.id, title: r.title, products: render_products(r), children: render_children(r) }}}
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

  # json格式为获取当前分类下的所有产品数据
  def show
    if params[:id] == "新品"
      new_products = Product.where( "created_at >= ?", (Date.today - 30).beginning_of_day )
    else
      @category = Category.includes(:products).find(params[:id])
    end
    respond_to do |format|
      format.html
      format.json{
        render :json => ( new_products || @category.products ).includes(:product_images).map{|p| {id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, image: p.main_image_thumb}}
      }
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, alert: "已删除"
    else
      redirect_to :back, alert: "操作失败，请联系程序员"
    end
  end

  # 页面版的更新栏位数据
  def update_column
    @category.image = params[:category][:image] if params[:category][:image].present?
    @category.weight = params[:category][:weight] if params[:category][:weight].present?
    @category.title = params[:category][:title] if params[:category][:title].present?
    @category.index_show = params[:category][:index_show] if params[:category][:index_show].present?
    @category.index_image = params[:category][:index_image] if params[:category][:index_image].present?
    @category.index_weight = params[:category][:index_weight] if params[:category][:index_weight].present?
    if @category.save
      redirect_to :back, notice: "已更新！"
    else
      redirect_to :back, alert: "操作失败，请联系管理员"
    end
  end
  # wechat端需要新增分类时，获取的分类列表
  def for_wechat_product_new_picker
    roots = Category.where(ancestry: nil)
    render :json => {title_arr: roots.map{|r| [r.title, ["- -"] + r.children.map{|c| c.title}]}, id_arr: roots.map{|r| [r.id, [00] + r.children.map{|c| c.id}]}, default_arr: [ roots.map{|r| r.title}, ["- -"] + roots.first.children.map{|c| c.title}], current_id: roots.first.id, current_title: roots.first.title}
  end

  def for_wechat_category_new_picker
    roots = Category.where(ancestry: nil)
    render :json => {title_arr: ["(新增一级分类)"] + roots.map{|r| r.title}, id_arr: ["00"] + roots.map{|r| r.id}}
  end


  # 新增来自wechat端
  def create_form_api
    # binding.pry
    category = Category.new title: params[:title], weight: params[:weight], ancestry: ( params[:parent_id] if params[:parent_id].present? )
    if category.save
      render :json => { status: "ok", id: category.id }
    else
      # binding.pry
      render :json => { status: "failed", info: category.errors.messages.values.flatten }
    end
  end

  # 更新来自wechat端
  def update_form_api
    category = Category.find(params[:id])
    category.title = params[:title] if params[:title].present?
    category.weight = params[:weight] if params[:weight].present?
    category.image = params[:image] if params[:image].present?
    category.ancestry = params[:parent_id] if params[:parent_id].present?
    if category.save
      render :json => {status: "ok", id: category.id}
    else
      # binding.pry
      render :json => { status: "failed", info: category.errors.messages.values.flatten }
    end
  end

  def update_image_form_api
    category = Category.find(params[:id])
    category.image = params[:image] if params[:image].present?
    if category.save
      render :json => "ok"
    else
      # binding.pry
      render :json => { status: "failed"}
    end
  end

  # 获取一条数据的详情
  def get_category_detail
    category = Category.find(params[:id])
    if category.present?
      render :json => { id: category.id, title: category.title, weight: category.weight, image: (category.image.url if category.image.present?)}
    end
  end

  def index_show
    @category.index_show = true
    if @category.save
      redirect_to :back, notice: "更新成功~"
    end
  end

  def index_hide
    @category.index_show = false
    if @category.save
      redirect_to :back, notice: "更新成功~"
    end
  end

  def delete_category
    title = @category.title
    if @category.destroy
      render :json => {status: "ok", info: "【#{title}】已删除！"}
    else
      render :json => {status: "failed", info: "删除失败，请联系程序员..."}
    end
  end




  # 私有方法
  private
  def category_params
    params.require(:category).permit(:title, :weight, :ancestry, :image)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def render_children(root)
    if root.children.present?
      return root.children.order(weight: 'asc').map{|c| { id: c.id, title: c.title, image: c.image.thumb.url }}
    end
  end

  def render_products(root)
    return root.products.map{|p| { id: p.id, title: truncate(p.title, length: 8), image: (p.product_images.present? ? p.product_images.shuffle.last.image.thumb.url : "")}}
  end
end
