class OrderForm
  include ActiveModel::Model
  attr_accessor :post_code, :prefecture_id, :city, :address, :building_name, :phone_number, :item_id, :user_id, :token

  with_options presence: true do
    validates :post_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: "is invalid. Include hyphen(-)" }
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :city
    validates :address
    validates :phone_number, format: { with: /\A[0-9]{10,11}\z/, message: "is invalid" }
    validates :user_id
    validates :item_id
    validates :token
  end

  def save
    return false unless valid?
    begin
      ActiveRecord::Base.transaction do
        pay_item
        order = Order.create!(user_id: user_id, item_id: item_id)
        Address.create!(post_code: post_code, prefecture_id: prefecture_id, city: city, address: address, building_name: building_name, phone_number: phone_number, order_id: order.id)
      end
    rescue ActiveRecord::RecordInvalid => e # ここで例外を捕捉
      e.record.errors.full_messages.each do |message|
      errors.add(:base, message) # エラーメッセージをOrderFormに追加
      end
      return false
    rescue Payjp::PayjpError => e
      return false
    end

    true
  end

  private

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: Item.find(item_id).price,
      card: token,
      currency: 'jpy'
    )
  end
end