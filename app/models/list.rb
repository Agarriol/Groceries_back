class List < ApplicationRecord
  before_validation :normalize_state, on: :create
  belongs_to :user
  # dependent: :destroy, al destroy este, destroy sus items
  has_many :items, dependent: :destroy

  validates :title, presence: true, length: {maximum: 100}
  validates :description, length: {maximum: 5000}
  validates :state, inclusion: {in: [true, false]} # Solo puede ser abierta o cerrada
  # TODO, si se introduce false es false, sino SIEMPRE es true

  scope :by_title, ->(title) { where('title LIKE ?', "%#{title}%") }
  scope :by_description, ->(description) { where('description LIKE ?', "%#{description}%") }

  private

  def normalize_state
    self.state = true if state.nil?
  end
end
