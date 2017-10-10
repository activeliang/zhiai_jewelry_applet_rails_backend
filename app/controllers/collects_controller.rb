class CollectsController < ApplicationController
  before_action :auth_admin_or_wechat_user
  # before_action :admin_required_site_or_wechat
  protect_from_forgery except: [:create_collect]
  def create_collect

    collect = Collect.where(wechat_user_id: current_wechat_user.id).where(product_id: params[:product_id]).first || Collect.new
    tag = collect.new_record?
    collect.product_id = params[:product_id]
    # binding.pry
    collect.wechat_user_id = current_wechat_user.id
    collect.product_name = params[:product_name]
    collect.image_url = params[:product_img]
    collect.save
    render :json => { status: "ok", info:  tag ? "已收藏！" : "已存在！" }
  end

  def remove_clooect
    # binding.pry
    collect =  Collect.where(wechat_user_id: current_wechat_user.id).where(product_id: params[:product_id])
    # binding.pry
    if collect.destroy_all
      render :json => { status: "ok", info: "已移除"}
    else
      render :json => { status: "failed", info: "操作失败，请稍候再试……" }
    end
  end

  def my_collects
    collect = Collect.where(wechat_user_id: current_wechat_user.id).where(is_exist: true)
    if collect.present?
      render :json => { status: "ok", my_collects: collect.map{|x| { id: x.product.id, title: x.product.title, sub_title: x.product.sub_title, price: x.product.price, image: x.product.main_image_thumb}} }
    else
      render :json => { status: "failed", info: "你目前没有收藏哦~" }
    end
  end
end
