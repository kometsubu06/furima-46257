FactoryBot.define do
  factory :order_form do
    post_code { '123-4567' }
    prefecture_id { 2 }
    city        { '東京都' }
    address     { '青山1-1-1' }
    building_name { '柳ビル103' }
    phone_number { '09012345678' }
    token { 'tok_abcdefghijklmnopqrstuvwxyz' }

    # user_idとitem_idは、テストケースでビルド時に渡す
    # association :user
    # association :item
  end
end
