require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '配送先情報の保存' do
    # letとFactoryBot.buildを使い、テストデータを準備します。
    # FactoryBotが関連(association)を辿り、必要なorder, user, itemもbuildしてくれます。
    let(:address) { FactoryBot.build(:address) }

    context '内容に問題ない場合' do
      it 'orderが紐付いていれば保存できること' do
        expect(address).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'orderが紐付いていないと保存できないこと' do
        address.order = nil
        address.valid?
        expect(address.errors.full_messages).to include('Order must exist')
      end
    end
  end
end
