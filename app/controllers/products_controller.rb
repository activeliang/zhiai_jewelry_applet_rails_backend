class ProductsController < ApplicationController
  before_action :auth_admin_or_wechat_user
  protect_from_forgery except: [:alipay_notify, :create_form_wechat, :update_form_wechat, :update_product_image, :add_product_image]

  # 首页
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category).paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.html
      format.json{
        if params[:q][:title_or_sub_title_cont].present?
          render :json => { products: render_search_result(@product) }
        else
          render :josn => { status: "failed", info: "undefined" }
        end
      }
    end
  end

  # 新增页面
  def new
    @product = Product.new
    @category_roots = Category.roots
  end

  # 新增产品
  def create
    @product = Product.new(product_params)
    if @product.save
      params[:product][:images].each do |img|
        @product.product_images << ProductImage.new(image: img)
      end
      redirect_to products_path, notice: "create success!新增成功~"
    else
      render :new
    end
  end

  # 微信端新增产品
  def create_form_wechat
    render json: create_form_wechat!(params)
  end

  # 微信端更新产品数据
  def update_form_wechat
      render json: update_form_wechat!(params)
  end

  # 微信端新增产品图片
  def add_product_image
    find_product
    @product.product_images.new image: params[:image]
    render :json => { status: "ok", id: params[:id]}
  end

  def show
    find_product
    respond_to do |format|
      format.html
      format.json{
        random_product = Product.includes(:product_images).order("RANDOM()").limit(15)
        p = @product
        # 小程序端产品detail页面
        render :json => {product: {id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, description: p.description, video: p.video.url, images: render_product_all_images(p) }, random_product: random_product.map{|p| { id: p.id, image: render_product_main_image(p), title: p.title, sub_title: p.sub_title, price: p.price}}, product_main_img: p.main_image_small}
      }
    end
  end

  def destroy
    if @product.destroy
      redirect_to :back, alert: "已删除！"
    else
      redirect_to :back, alert: "删除失败，请联系管理员！"
    end
  end

  # 小程序端编辑产品时获取产品详情
  def get_product_detail
    p = Product.find(params[:id])
    render :json => {id: p.id, title: p.title, sub_title: p.sub_title, description: p.description, price: p.price, video: p.video, weight: p.weight, index_show: p.index_show, in_stock: p.in_stock, is_hide: p.is_hide, image: p.product_images.order(weight: 'asc').map{|i| i.image.url}, category_id: p.category_id, category_title: p.category.title}
  end

  def change_is_hide_status
    change_is_hide_status!(params[:id])
    redirect_to :back, notice: "更新成功！"
  end

   def change_in_stock_status
     change_in_stock_status!(params[:id])
     redirect_to :back, notice: "更新成功！"
   end

   def chage_index_show_status
     find_product
     if @product.index_show
       @product.index_show = false
     else
       @product.index_show = true
     end
     @product.save

     redirect_to :back, notice: "更新成功！"
   end

   def delete_form_wechat
     find_product
     title = @product.title
     if @product.destroy
       render json: {status: "ok", info: "【#{title}】已删除~！"}
     end
   end


  private
  def product_params
    params.require(:product).permit(:title, :sub_title, :description, :video, :in_sale, :index_show, :weight, :price, :is_hide, :category_id)
  end

  def find_product
    @product = Product.find(params[:id])
  end

  def render_product_all_images(product)
    if product.product_images.present?
      product.product_images.order(weight: "asc").map{|i| i.image.medium.url}
    end
  end

  def render_product_main_image(product)
    if product.product_images.present?
      product.product_images.shuffle.first.image.thumb.url
    end
  end

  def render_redis_key(str1, str2)
    "product_temfile:#{str1}:#{str2}"
  end

  def copy_file(from, to)
    File.open(from) do |input|
      File.open(to, "w") do |output|
        output.write(input.read)
      end
    end
  end
end
