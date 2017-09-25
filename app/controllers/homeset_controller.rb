class HomesetController < ApplicationController
  before_action :find_slider_image, only: [:update_column, :destroy, :hide, :public]
  def index
    @slider_images = WechatSliderImage.order(weight: 'asc')
    respond_to do |format|
      format.html{
        @slider_image = WechatSliderImage.new
      }
      format.json{
        index_category = Category.where(index_show: true).order(index_weight: 'asc')
        render :json => {slider_images: @slider_images.map{|x| {image: x.image.url, id: x.id}}, index_category: index_category.map{|x| { id: x.id, title: x.title, image: x.index_image.url}}}
      }

    end
  end

  def create
    params[:wechat_silder_image][:images].each do |img|
      @slider_image = WechatSliderImage.create(image: img)
    end
    redirect_to :back, notice: "新增成功！"
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

  private

  def find_slider_image
    @slider_image = WechatSliderImage.find(params[:id])
  end

  def params_slider_image
    params.require(:wechat_slider_image).permit(:image, :weight, :is_hide)
  end
end
