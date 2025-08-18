class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create]
  before_action :set_item, only: [:index, :create]
  before_action :move_to_index, only: [:index, :create]

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @order_form = OrderForm.new
  end

  def create
    @item = Item.find(params[:item_id])
    @order_form = OrderForm.new(order_params.merge(user_id: current_user.id, item_id: params[:item_id]))
    Rails.logger.debug '===== DEBUG ====='
    Rails.logger.debug "params[:order_form][:token] => #{params[:order_form][:token]}"
    Rails.logger.debug "order_params[:token] => #{order_params[:token]}"
    Rails.logger.debug "@order_form.token => #{@order_form.token}"
    Rails.logger.debug '================='
    # binding.pry
    if @order_form.valid?
      @order_form.save
      # pay_item
      redirect_to root_path
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      render :index, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order_form).permit(:post_code, :prefecture_id, :city, :address, :building_name, :phone_number, :token)
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # 自身のPAY.JPテスト秘密鍵を記述しましょう
    Payjp::Charge.create(
      amount: @item.price, # 商品の値段
      card: order_params[:token], # カードトークン
      currency: 'jpy' # 通貨の種類（日本円）
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_index
    return unless @item.user_id == current_user.id || @item.order.present?

    redirect_to root_path
  end
end
