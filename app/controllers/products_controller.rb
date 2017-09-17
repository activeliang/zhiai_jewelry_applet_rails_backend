class ProductsController < ApplicationController

  def index
    @products = Product.includes(:category).paginate(:page => params[:page], :per_page => 10)
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
