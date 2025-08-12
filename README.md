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
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| item_name          | string     | null: false                    |
| item_description   | text       | null: false                    |
| category           | references | null: false, foreign_key: true |
| condition          | references | null: false, foreign_key: true |
| shipping_fee       | references | null: false, foreign_key: true |
| prefecture         | references | null: false, foreign_key: true |
| shipping_day       | references | null: false, foreign_key: true |
| price              | integer    | null: false                    |
| user               | references | null: false                    |

### Association
- belongs_to :user
- belongs_to :category
- belongs_to :condition
- belongs_to :shipping_fee
- belongs_to :prefecture
- belongs_to :shipping_day
- has_one :order

#### orderテーブル
| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| items   | references | null: false, foreign_key: true |
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
| building     | string     | null: false               |
| phone_number | string     | null: false               |
| order        | references | null: false, unique: true |

##### Association
- belongs_to :order
- belongs_to :prefecture

# prefecturesテーブル
| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

# Association
- has_many :items

# shipping_feesテーブル
| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

# Association
- has_many :items

# conditionsテーブル
| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

# Association
- has_many :items

# shipping_daysテーブル
| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

# Association
- has_many :items

# categoriesテーブル
| Column | Type   | Options     |
| ------ | ------ | ----------- |
| name   | string | null: false |

# Association
- has_many :items