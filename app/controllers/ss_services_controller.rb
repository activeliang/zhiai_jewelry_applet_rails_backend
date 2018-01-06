class SsServicesController < ApplicationController
  before_action :auth_admin_or_wechat_user

  def index
    @ss_services = SsService.all
  end

  def new
    @ss_service = SsService.new
  end

  def show
    find_item
  end

  def create
    if @ss_service = SsService.generate_service(params[:ss_service][:service_ip])
      redirect_to ss_services_path, notice: "增加成功"
    else
      redirect_to ss_services_path, notice: "失败！"
    end
  end

  def show
    find_item
  end

  private
    def find_item
      @ss_service = SsService.find(params[:id])
    end
end
