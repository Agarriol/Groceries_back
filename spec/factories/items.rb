FactoryBot.define do
  factory :item do
    name { generate :name_sequence }
    price 4.5
    list_id 1
    user_id 1
  end

  sequence :name_sequence do |n|
    "item #{n}"
  end
end
