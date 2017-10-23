class HomesetController < ApplicationController
  before_action :auth_admin_or_wechat_user
  before_action :find_slider_image, only: [:update_column, :destroy, :hide, :public]

  def index
    @slider_images = WechatSliderImage.order(weight: 'asc')
    respond_to do |format|
      format.html{
        @homeset = Homeset.first || Homeset.create(shop_title: "初始化，未设置")
        @slider_image = WechatSliderImage.new
        @homeset_new = Homeset.new
      }
      format.json{
        products = Product.select_index_show.ascend
        index_category = Category.where(index_show: true).order(index_weight: 'asc')
        render :json => {index_category: index_category.map{|x| { id: x.id, title: x.title, image: x.index_image.url}}, products: products.map{|x| {id: x.id, title: x.title, sub_title: x.sub_title, small_image: x.main_image_small, thumb_image: x.main_image_thumb, price: x.price}} }
      }
    end
  end

  def create
    if params[:wechat_silder_image].present?
      params[:wechat_silder_image][:images].each do |img|
        @slider_image = WechatSliderImage.create(image: img)
      end
      redirect_to :back, notice: "新增成功！"
    else
      redirect_to :back, alert: "您没有选择文件！"
    end
  end

  def update_column
    redirect_to :back, notice: @slider_image.update_column(params)
  end

  def update_column_homeset
    redirect_to :back, notice: Homeset.update_column(params)
  end

  def destroy
    if @slider_image.destroy
      redirect_to :back, alert: "已删除！"
    end
  end

  def hide
    @slider_image.change_is_hide_status!
    redirect_to :back, notice: "已更改！"
  end

  def get_wechat_homeset
    homeset = Homeset.first || Homeset.create(shop_title: "初始化，未设置")
    slider_images = WechatSliderImage.order(weight: 'asc')
    render :json => { homeset: homeset, shop_images: slider_images.map{|x| x.image.medium.url} }
  end

  private

  def find_slider_image
    @slider_image = WechatSliderImage.find(params[:id])
  end

  def params_slider_image
    params.require(:wechat_slider_image).permit(:image, :weight, :is_hide)
  end
end
