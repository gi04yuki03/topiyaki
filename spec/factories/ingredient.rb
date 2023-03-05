FactoryBot.define do
  factory :ingredient do
    sequence(:ingredient)  { "材料１" }
    sequence(:quantity)    { "分量１" }
  end
end
