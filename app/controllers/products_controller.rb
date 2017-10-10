class ProductsController < ApplicationController
  before_action :auth_admin_or_wechat_user
  before_action :admin_required_site_or_wechat, only: [:create_form_wechat, :update_form_wechat, :update_product_image ]
  protect_from_forgery except: [:alipay_notify, :create_form_wechat, :update_form_wechat, :update_product_image]
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category).paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.html
      format.json{
        if params[:q][:title_or_sub_title_cont].present?
          render :json => { products: @products.map{|p| { id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, image: p.main_image_thumb}}, paginate: { current_page: @products.current_page, previous_page: @products.previous_page, next_page: @products.next_page, total_page: @products.total_pages}}
        else
          render :josn => {status: "error"}
        end
      }
    end
  end

  def new
    @product = Product.new
    @category_roots = Category.roots
  end

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

  def create_form_wechat
    product = Product.new title: params[:title],  sub_title: params[:sub_title], category_id: params[:category_id], description: params[:description], weight: params[:weight], price: params[:price], index_show: params[:index_show], is_hide: params[:is_hide], in_stock: params[:in_stock]
    if product.save
      render :json => { status: "ok", id: product.id }
    else
      render :json => { status: "failed", info: product.errors.messages.values.flatten }
    end
    # binding.pry
  end

  def update_form_wechat
    product = Product.find(params[:id])
      product.title = params[:title] if params[:title].present?
      product.sub_title = params[:sub_title] if params[:sub_title].present?
      product.description = params[:description] if params[:description].present?
      product.video = params[:video] if params[:video].present?
      product.price = params[:price] if params[:price].present?
      product.in_stock = params[:in_stock] if params[:in_stock].present?
      product.index_show = params[:index_show] if params[:index_show].present?
      product.is_hide = params[:is_hide] if params[:is_hide].present?
      product.weight = params[:weight] if params[:weight].present?

      if product.save!
        render :json => {status: "ok", id: product.id}
      else
        render :json => { status: "failed", info: product.errors.messages.values.flatten }
      end

  end

  def add_product_image
    # product = Product.find(params[:id])
    # product.product_images.create! image: params[:image] if params[:image].present?
    binding.pry
    p = ProductImage.create product_id: params[:id], image: params[:image] if params[:image].present?
    render :json => "ok"
  end

  def show
    find_product
    respond_to do |format|
      format.html
      format.json{
        random_product = Product.includes(:product_images).order("RANDOM()").limit(15)
        p = @product
        # binding.pry
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

  def get_product_detail
    p = Product.find(params[:id])
    render :json => {id: p.id, title: p.title, sub_title: p.sub_title, description: p.description, price: p.price, video: p.video, weight: p.weight, index_show: p.index_show, in_stock: p.in_stock, is_hide: p.is_hide, image: p.product_images.order(weight: 'asc').map{|i| i.image.url}, category_id: p.category_id, category_title: p.category.title}
  end

   def change_is_hide_status
     find_product
     if @product.is_hide
       @product.is_hide = false
     else
       @product.is_hide = true
     end
     @product.save

     redirect_to :back, notice: "更新成功！"
   end

   def change_in_stock_status
     find_product
     if @product.in_stock
       @product.in_stock = false
     else
       @product.in_stock = true
     end
     @product.save

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
      product.product_images.first.image.thumb.url
    end
  end
end
