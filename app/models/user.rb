class User < ApplicationRecord
  include RailsJwtAuth::Authenticatable

  validates :name, presence: true, length: {maximum: 100}
end
