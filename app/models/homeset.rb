class Homeset < ApplicationRecord
  mount_uploader :banner, HomeBannerUploader
  mount_uploader :logo, HomeBannerUploader
  mount_uploader :shop_video, HomeVideoUploader


  def self.update_column(params)
    homeset = Homeset.find params[:id]
    homeset.banner = params[:homeset][:banner] if params[:homeset][:banner].present?
    homeset.shop_title = params[:homeset][:shop_title] if params[:homeset][:shop_title].present?
    homeset.open_time = params[:homeset][:open_time] if params[:homeset][:open_time].present?
    homeset.address = params[:homeset][:address] if params[:homeset][:address].present?
    homeset.phone_no = params[:homeset][:phone_no] if params[:homeset][:phone_no].present?
    homeset.shop_video = params[:homeset][:shop_video] if params[:homeset][:shop_video].present?
    homeset.logo = params[:homeset][:logo] if params[:homeset][:logo].present?
    return homeset.save ? "更新成功..." : "更新失败，请反馈给程序员..."
  end
end
