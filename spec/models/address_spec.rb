require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '配送先情報の保存' do
    before do
      # Addressをテストするには、関連するOrderが必要です。
      # また、有効なOrderを作成するにはUserとItemが必要なため、先に作成します。
      @user = FactoryBot.create(:user)
      @item = FactoryBot.create(:item)
      @order_form = FactoryBot.build(:order_form, user_id: @user.id, item_id: @item.id)
      # 作成したorderに関連付くaddressのインスタンスを生成します。
      @address = FactoryBot.build(:address, order_id: @order.id)
    end

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(@address).to be_valid
      end

      it 'building_nameは空でも保存できること' do
        @address.building_name = ''
        expect(@address).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'post_codeが空だと保存できないこと' do
        @address.post_code = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("Post code can't be blank")
      end

      it 'post_codeは「3桁ハイフン4桁」の半角文字列でないと保存できないこと' do
        @address.post_code = '1234567'
        @address.valid?
        expect(@address.errors.full_messages).to include('Post code is invalid. Enter it correctly with a hyphen.')
      end

      it 'prefecture_idが1では保存できないこと' do
        @address.prefecture_id = 1
        @address.valid?
        expect(@address.errors.full_messages).to include('Prefecture must be other than 1')
      end

      it 'cityが空だと保存できないこと' do
        @address.city = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("City can't be blank")
      end

      it 'addressが空だと保存できないこと' do
        @address.address = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("Address can't be blank")
      end

      it 'phone_numberが空だと保存できないこと' do
        @address.phone_number = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("Phone number can't be blank")
      end

      it 'phone_numberが9桁以下だと保存できないこと' do
        @address.phone_number = '090123456'
        @address.valid?
        expect(@address.errors.full_messages).to include('Phone number is invalid')
      end

      it 'phone_numberが12桁以上だと保存できないこと' do
        @address.phone_number = '090123456789'
        @address.valid?
        expect(@address.errors.full_messages).to include('Phone number is invalid')
      end

      it 'phone_numberにハイフンが含まれていると保存できないこと' do
        @address.phone_number = '090-1234-5678'
        @address.valid?
        expect(@address.errors.full_messages).to include('Phone number is invalid')
      end

      it 'phone_numberが半角数値でないと保存できないこと' do
        @address.phone_number = '０９０１２３４５６７８'
        @address.valid?
        expect(@address.errors.full_messages).to include('Phone number is invalid')
      end

      it 'orderが紐付いていないと保存できないこと' do
        @address.order_id = nil
        @address.valid?
        expect(@address.errors.full_messages).to include('Order must exist')
      end
    end
  end
end
