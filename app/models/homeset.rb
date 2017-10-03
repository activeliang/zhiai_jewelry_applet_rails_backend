class Homeset < ApplicationRecord
  mount_uploader :banner, HomeBannerUploader
  mount_uploader :logo, HomeBannerUploader
  mount_uploader :shop_video, HomeVideoUploader
end
