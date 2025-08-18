require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '購入記録の保存' do
    before do
      # Orderをテストするには、関連するUserとItemが必要です。
      user = create(:user)
      item = create(:item)
      # 作成したuserとitemに関連付くorderのインスタンスを生成します。
      @order = build(:order, user: user, item: item)
    end

    context '内容に問題ない場合' do
      it 'userとitemが紐付いていれば保存できる' do
        expect(@order).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'userが紐付いていないと保存できない' do
        @order.user = nil
        @order.valid?
        expect(@order.errors.full_messages).to include('User must exist')
      end
      it 'itemが紐付いていないと保存できない' do
        @order.item = nil
        @order.valid?
        expect(@order.errors.full_messages).to include('Item must exist')
      end
    end
  end
end
