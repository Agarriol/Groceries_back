class Item < ApplicationRecord
  belongs_to :list
  belongs_to :user
  has_many :votes, dependent: :destroy

  # uniqueness:{scope: %i[list_id]}, tiene que ser unico en una misma lista,se puede repetir en otra
  validates :name, presence: true, uniqueness: {scope: %i[list_id]}, length: {maximum: 100}
  validates :price, presence: true, numericality: {allow_blank: true}
end
