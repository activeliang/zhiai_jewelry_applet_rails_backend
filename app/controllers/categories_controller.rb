class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "新增成功！"
    else
      render :back
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :weight)
  end
end
