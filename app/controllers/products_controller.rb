class ProductsController < ApplicationController
  protect_from_forgery except: [:alipay_notify, :create_form_wechat, :update_form_wechat, :update_product_image]

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category).paginate(:page => params[:page], :per_page => 25)
    respond_to do |format|
      format.html
      format.json{
        if params[:q][:title_or_sub_title_cont].present?
          render :json => { products: @products.map{|p| { id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, image: p.main_image}}, paginate: { current_page: @products.current_page, previous_page: @products.previous_page, next_page: @products.next_page, total_page: @products.total_pages}}
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
      redirect_to products_path, notice: "create success!新增成功~"
    else
      render :new
    end
  end

  def create_form_wechat
    product = Product.new title: params[:title],  sub_title: params[:sub_title], category_id: params[:category_id], images: params[:images], description: params[:description], weight: params[:weight], price: params[:price], index_show: params[:index_show], is_hide: params[:is_hide], in_stock: params[:in_stock]
    if product.save
      render :json => {status: "ok", id: product.id}
    else
      render :json => {status: "新增失败，请联系管理员"}
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
        render :json => {status: "failed"}
      end

  end

  def update_product_image
    # product = Product.find(params[:id])
    # product.product_images.create! image: params[:image] if params[:image].present?
    # binding.pry
    p = ProductImage.create product_id: params[:id], image: params[:image] if params[:image].present?
    render :json => {status: "ok", id: p.id}
  end

  def show
    find_product
    respond_to do |format|
      format.html
      format.json{
        random_product = Product.order("RANDOM()").limit(15)
        p = @product
        render :json => {product: {id: p.id, title: p.title, sub_title: p.sub_title, price: p.price, description: p.description, video: p.video, images: p.images.split("&")}, random_product: random_product.map{|p| { id: p.id, image: p.main_image, title: p.title, sub_title: p.sub_title, price: p.price}}}
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

  private
  def product_params
    params.require(:product).permit(:title, :sub_title, :description, :video, :in_sale, :index_show, :weight, :price, :is_hide, :category_id, :images => [])
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
