class CollectsController < ApplicationController
  before_action :auth_admin_or_wechat_user
  # before_action :admin_required_site_or_wechat
  protect_from_forgery except: [:create_collect]

  def create_collect
    render json: current_wechat_user.collection_do(params)
  end

  def remove_clooect
    if current_wechat_user.collects.find_by_product_id(params[:product_id]).destroy
      render :json => { status: "ok", info: "已移除"}
    else
      render :json => { status: "failed", info: "操作失败，请稍候再试……" }
    end
  end

  def my_collects
    collects = current_wechat_user.collects
    if collects.present?
      render :json => { status: "ok", my_collects: collects.map{|x| { id: x.product.id, title: x.product.title, sub_title: x.product.sub_title, price: x.product.price, image: x.product.main_image_thumb}} }
    else
      render :json => { status: "failed", info: "你目前没有收藏哦~" }
    end
  end
end
