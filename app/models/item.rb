class Item < ApplicationRecord
  belongs_to :list
  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: {maximum: 100}
  validates :price, presence: true, numericality: true
end