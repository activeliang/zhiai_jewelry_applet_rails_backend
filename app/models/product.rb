class Product < ApplicationRecord
  # mount_uploaders :images, ProductImageUploader
  # mount_uploader :video, ProductVideoUploader
  serialize :images, JSON

  belongs_to :category



  def main_image
    self.images.split("&").first
  end
end
