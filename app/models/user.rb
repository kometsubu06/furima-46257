class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  with_options presence: true do
    validates :nickname
    validates :last_name, format: { with: /\A[ぁ-んァ-ン一-龥々ーヶヵ]+\z/, message: 'must be full-width characters' }
    validates :first_name, format: { with: /\A[ぁ-んァ-ン一-龥々ーヶヵ]+\z/, message: 'must be full-width characters' }
    validates :last_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: 'must be full-width katakana characters' }
    validates :first_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: 'must be full-width katakana characters' }
    validates :birthday
  end

  # パスワードのフォーマットを検証するバリデーションを追加
  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates_format_of :password, with: PASSWORD_REGEX, message: 'must include both letters and numbers'

  has_many :orders
  has_many :items

  # 購入済みかどうかを判定
  def ordered?
    order.present?
  end
end
