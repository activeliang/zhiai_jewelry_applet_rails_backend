class CategoriesController < ApplicationController
  before_action :auth_admin_or_wechat_user
  # before_action :admin_required_site_or_wechat
  protect_from_forgery except: [:create_form_api, :update_form_api, :update_image_form_api]
  before_action :find_category, only: [:show, :update_column, :destroy, :change_index_show_status, :delete_category, :update_form_api, :get_category_detail]

  def index
    @category_roots = Category.includes(:products).roots.ascend
    @category = Category.new
    respond_to do |format|
      format.html{
        @index_show_category = Category.where(index_show: true).order(index_weight: 'asc')
      }
      format.json{
        # 返回小程序端的分类树
        render json: Category.render_category_tree
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
    new_products = Product.where( "created_at >= ?", (Date.today - 30).beginning_of_day ) if params[:id] == "新品"
    respond_to do |format|
      format.html
      format.json{
        # 返回小程序端分类下产品列表
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
    render json: @category.update_form_website(params, "website")
  end

  # wechat端需要新增分类时，获取的分类列表
  def for_wechat_product_new_picker
    roots = Category.where(ancestry: nil)
    render :json => {title_arr: roots.map{|r| [r.title, ["- -"] + r.children.map{|c| c.title}]}, id_arr: roots.map{|r| [r.id, [00] + r.children.map{|c| c.id}]}, default_arr: [ roots.map{|r| r.title}, ["- -"] + roots.first.children.map{|c| c.title}], current_id: roots.first.id, current_title: roots.first.title}
  end

  # 为小程序端获取一级分类
  def for_wechat_category_new_picker
    roots = Category.where(ancestry: nil)
    render :json => {title_arr: ["(新增一级分类)"] + roots.map{|r| r.title}, id_arr: ["00"] + roots.map{|r| r.id}}
  end


  # 新增来自wechat端
  def create_form_api
    category = Category.new title: params[:title], weight: params[:weight], ancestry: ( params[:parent_id] if params[:parent_id].present? )
    if category.save
      render :json => { status: "ok", id: category.id }
    else
      render :json => { status: "failed", info: category.errors.messages.values.flatten }
    end
  end

  # 由wechat端发起更新
  def update_form_api
    render json: @category.update_form_api(params)
  end


  # 获取一条数据的详情，用于编辑
  def get_category_detail
    if @category.present?
      render :json => { id: @category.id, title: @category.title, weight: @category.weight, image: (@category.image.url if @category.image.present?)}
    end
  end

  # 更改index_show的状态
  def change_index_show_status
    @category.change_index_show_status!
    redirect_to :back, notice: "更新成功~"
  end

  # 由小程序端更改category状态
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

  def find_root
    returnroots = Category.where(ancestry: nil)
  end

end
