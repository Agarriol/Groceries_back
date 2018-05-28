class List < ApplicationRecord
  before_validation :normalize_state, on: :create
  belongs_to :user
  has_many :items

  validates :title, presence: true, length: {maximum: 100}
  validates :description, length: {maximum: 5000}
  validates :state, inclusion: {in: [true, false]} # Solo puede ser abierta o cerrada
  # TODO, si se introduce false es false, sino SIEMPRE es true

  private

  def normalize_state
    self.state = true if state.nil?
  end
end
