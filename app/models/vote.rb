class Vote < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :item_id, uniqueness: {scope: %i[user_id]}

end
