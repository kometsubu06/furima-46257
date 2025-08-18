require 'rails_helper'

RSpec.describe OrderForm, type: :model do
  describe '購入情報の保存' do
    let(:user) { create(:user) }
    let(:item) { create(:item) }
    let(:order_form) { build(:order_form, user_id: user.id, item_id: item.id) }

    before do
      # Pay.jpのAPI通信をモック化し、テスト中に外部APIへリクエストが飛ばないようにする
      # 正常なレスポンスを返すように設定
      allow(Payjp::Charge).to receive(:create).and_return(true)
    end

    context '内容に問題ない場合' do
      it 'すべての値が正しく入力されていれば保存できること' do
        expect(order_form).to be_valid
      end

      it '建物名は空でも保存できること' do
        order_form.building_name = ''
        expect(order_form).to be_valid
      end

      it 'saveメソッドが呼ばれると、OrderとAddressのレコードが作成されること' do
        expect do
          order_form.save
        end.to change(Order, :count).by(1).and change(Address, :count).by(1)
      end
    end

    context '内容に問題がある場合' do
      it 'tokenが空だと保存できないこと' do
        order_form.token = nil
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Token can't be blank")
      end

      it '郵便番号が空だと保存できないこと' do
        order_form.post_code = ''
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Post code can't be blank")
      end

      it '郵便番号が半角のハイフンを含んだ正しい形式でないと保存できないこと' do
        order_form.post_code = '1234567'
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Post code はハイフンを含めて正しく入力してください')
      end

      it '都道府県が1だと保存できないこと' do
        order_form.prefecture_id = 1
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Prefecture を選択してください')
      end

      it '市町村が空だと保存できないこと' do
        order_form.city = ''
        order_form.valid?
        expect(order_form.errors.full_messages).to include("City can't be blank")
      end

      it '番地が空だと保存できないこと' do
        order_form.address = ''
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Address can't be blank")
      end

      it '電話番号が空だと保存できないこと' do
        order_form.phone_number = ''
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号が9桁以下だと保存できないこと' do
        order_form.phone_number = '090123456'
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は不正な値です')
      end

      it '電話番号が12桁以上だと保存できないこと' do
        order_form.phone_number = '090123456789'
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は不正な値です')
      end

      it '電話番号が半角数値でないと保存できないこと' do
        order_form.phone_number = '０９０１２３４５６７８'
        order_form.valid?
        expect(order_form.errors.full_messages).to include('Phone number は不正な値です')
      end

      it 'user_idが空だと保存できないこと' do
        order_form.user_id = nil
        order_form.valid?
        expect(order_form.errors.full_messages).to include("User can't be blank")
      end

      it 'item_idが空だと保存できないこと' do
        order_form.item_id = nil
        order_form.valid?
        expect(order_form.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
