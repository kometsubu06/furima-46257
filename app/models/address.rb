class Address < ApplicationRecord
  belongs_to :order
  with_options presence: true do
    validates :post_code
    validates :prefecture_id, numericality: { other_than: 1, message: 'must be other than 1' }
    validates :city
    validates :address
    validates :phone_number
  end

  validates :post_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Enter it correctly with a hyphen.' },
                        allow_blank: true
  validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }, allow_blank: true
end
