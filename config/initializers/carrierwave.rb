CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = Rails.application.qiniu_access_key
  config.qiniu_secret_key    = Rails.application.qiniu_secret_key
  config.qiniu_bucket        = Rails.application.qiniu_bucket
  config.qiniu_bucket_domain = Rails.application.qiniu_bucket_domain
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
  config.qiniu_up_host       = "http://up-z1.qiniu.com"  #选择不同的区域时，"up.qiniu.com" 不同

end
