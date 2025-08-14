class ItemsController < ApplicationController
  def index
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).params(:image, :item_name, :description, :category_id, :item_status_id, :shipping_cost_id,
                                 :prefecture_id, :shipping_day_id, :price).merge(user_id: current_user.id)
  end
end
