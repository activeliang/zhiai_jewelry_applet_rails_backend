class WechatSliderImage < ApplicationRecord

  mount_uploader :image, SliderImageUploader
  
end
