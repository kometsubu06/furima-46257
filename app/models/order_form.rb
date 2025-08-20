class OrderForm
  include ActiveModel::Model
  attr_accessor :post_code, :prefecture_id, :city, :address, :building_name, :phone_number, :user_id, :item_id, :token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :post_code
    validates :prefecture_id
    validates :city
    validates :address
    validates :phone_number
    validates :token
  end

  validates :post_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/ },
                        allow_blank: true
  validates :phone_number, format: { with: /\A\d{10,11}\z/ }, allow_blank: true

  def save
    # 支払い処理
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    begin
      Payjp::Charge.create(
        amount: Item.find(item_id).price,
        card: token,
        currency: 'jpy'
      )
    rescue Payjp::PayjpError => e
      errors.add(:base, 'カード情報が正しくありません。')
      return false
    end

    # OrderとAddressの保存
    order = Order.create!(user_id: user_id, item_id: item_id)
    Address.create!(post_code: post_code, prefecture_id: prefecture_id, city: city, address: address,
                    building_name: building_name, phone_number: phone_number, order_id: order.id)
  end
end
