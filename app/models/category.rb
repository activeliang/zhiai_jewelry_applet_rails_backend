class Category < ApplicationRecord
  mount_uploader :image, CategoryImageUploader
  mount_uploader :index_image, HomepageCategoryImageUploader

  validates_presence_of :title, message: "标题不能为空！"
  #  validate :validate_image_or_ancestry, on: [:create, :update]




  has_ancestry
  has_many :products, dependent: :destroy


  # private

  # def validate_image_or_ancestry
  #   if self.ancestry
  #     unless self.image.present?
  #       self.errors.add(:image, "提交二级分类时图片不能为空！")
  #       return false
  #     end
  #   end
  # end

end
