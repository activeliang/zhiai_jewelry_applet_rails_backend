class Category < ApplicationRecord
  mount_uploader :image, CategoryImageUploader
  has_ancestry
  has_many :products
end
