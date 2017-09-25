class Category < ApplicationRecord
  mount_uploader :image, CategoryImageUploader
  mount_uploader :index_image, HomepageCategoryImageUploader
  has_ancestry
  has_many :products
end
