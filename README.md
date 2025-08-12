## usersテーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| nickname           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |
| last_name          | string | null: false               |
| first_name         | string | null: false               |
| last_name_kana     | string | null: false               |
| first_name_kana    | string | null: false               |
| birthday           | date   | null: false               |

## Association

- has_many :items
- has_many :orders

### itemsテーブル
| Column             | Type       | Options                  |
| ------------------ | ---------- | ------------------------ |
| item_name          | string     | null: false              |
| item_description   | text       | null: false              |
| category_id        | integer    | null: false              |
| condition_id       | integer    | null: false              |
| shipping_fee_id    | integer    | null: false              |
| prefecture_id      | integer    | null: false              |
| shipping_day_id    | integer    | null: false              |
| price              | integer    | null: false              |
| user               | references | null: false, foreign_key |

### Association
- belongs_to :user
- has_one :order

#### orderテーブル
| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| item    | references | null: false, foreign_key: true |
| user    | references | null: false, foreign_key: true |

#### Association
- belongs_to :item
- belongs_to :user
- has_one :address

##### addressesテーブル
| Column       | Type       | Options                   |
| ------------ | ---------- | ------------------------- |
| postal_code  | string     | null: false               |
| prefecture   | references | null: false               |
| city         | string     | null: false               |
| addresses    | string     | null: false               |
| building     | string     |                           |
| phone_number | string     | null: false               |
| order        | references | null: false, unique: true |

##### Association
- belongs_to :order


