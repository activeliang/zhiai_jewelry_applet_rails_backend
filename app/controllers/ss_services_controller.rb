class SsServicesController < ApplicationController
  before_action :auth_admin_or_wechat_user

  def index
    @ss_services = SsService.all
  end

  def new
    @ss_service = SsService.new
  end

  def create
    if @ss_service = SsService.generate_service(params[:ss_service][:service_ip])
      redirect to ss_services_path, notice: "增加成功"
    else
      redirect to ss_services_path, notice: "失败！"
    end
  end

  def show
    find_item
  end

  private
    def find_item
      @ss_service = SsSerivce.find(params[:id])
    end
end
