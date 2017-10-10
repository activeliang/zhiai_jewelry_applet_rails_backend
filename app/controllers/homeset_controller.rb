class HomesetController < ApplicationController
  before_action :auth_admin_or_wechat_user
  before_action :find_slider_image, only: [:update_column, :destroy, :hide, :public]
  def index
    @slider_images = WechatSliderImage.order(weight: 'asc')
    respond_to do |format|
      format.html{
        homeset_all = Homeset.first
        if homeset_all.present?
          @homeset = homeset_all
        else
          @homeset = Homeset.create shop_title: "初始化，未设置"
        end
        @slider_image = WechatSliderImage.new
        @homeset_new = Homeset.new
      }
      format.json{
        products = Product.where(index_show: true).order(weight: 'asc')
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
    @slider_image.weight = params[:wechat_silder_image][:weight] if params[:wechat_silder_image][:weight].present?
    @slider_image.is_hide = params[:wechat_silder_image][:is_hide] if params[:wechat_silder_image][:is_hide].present?
    @slider_image.product_id = params[:wechat_silder_image][:product_id] if params[:wechat_silder_image][:product_id].present?

    if @slider_image.save
      redirect_to :back, notice: "更新成功……"
    else
      redirect_to :back, alert: "更新失败，请联系管理员！"
    end
  end

  def update_column_homeset
    @homeset = Homeset.find params[:id]
    @homeset.banner = params[:homeset][:banner] if params[:homeset][:banner].present?
    @homeset.shop_title = params[:homeset][:shop_title] if params[:homeset][:shop_title].present?
    @homeset.open_time = params[:homeset][:open_time] if params[:homeset][:open_time].present?
    @homeset.address = params[:homeset][:address] if params[:homeset][:address].present?
    @homeset.phone_no = params[:homeset][:phone_no] if params[:homeset][:phone_no].present?
    @homeset.shop_video = params[:homeset][:shop_video] if params[:homeset][:shop_video].present?
    @homeset.logo = params[:homeset][:logo] if params[:homeset][:logo].present?
    if @homeset.save
      redirect_to :back, notice: "更新成功..."
    else
      redirect_to :back, alert: "更新失败，请反馈给程序员..."
    end
  end

  def destroy
    if @slider_image.destroy
      redirect_to :back, alert: "已删除！"
    end
  end

  def hide
    @slider_image.is_hide = true
    if @slider_image.save
      redirect_to :back, notice: "已更新"
    end
  end

  def public
    @slider_image.is_hide = false
    if @slider_image.save
      redirect_to :back, notice: "已更新"
    end
  end

  def get_wechat_homeset
    homeset_all = Homeset.first
    if homeset_all.present?
      homeset = homeset_all
    else
      homeset = Homeset.create shop_title: "初始化，未设置"
    end
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
