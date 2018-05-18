FactoryBot.define do
  factory :user do
    name 'name'
    email { generate :email_sequence }
    password '12345678'
    password_confirmation '12345678'
  end

  sequence :email_sequence do |n|
    "email#{n}@email.com"
  end
end
