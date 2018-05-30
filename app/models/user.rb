class User < ApplicationRecord
  include RailsJwtAuth::Authenticatable
  has_many :lists
  has_many :items
  has_many :votes

  validates :name, presence: true, length: {maximum: 100}
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, if: :password

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  def to_token_payload(_request)
    {
      # Esto es current_user.to_token_payload, así que self (this) es el user actual.
      auth_token: regenerate_auth_token,
      user: name, # es como pones self.name
      userEmail: email,
      userId: id
    }
  end
end
