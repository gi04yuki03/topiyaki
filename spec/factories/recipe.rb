FactoryBot.define do
  factory :recipe do
    sequence(:title)       { "テストタイトル" }
    sequence(:description) { "テストディスクリプション" }
    association            :user

    trait :with_ingredients do
      after(:build) do |recipe|
        ingredient = build(:ingredient)
        recipe.ingredients << ingredient
      end
    end

    trait :with_procedures do
      after(:build) do |recipe|
        procedure = build(:procedure)
        recipe.procedures << procedure
      end
    end

    factory :recipe_with_ingredients_and_procedures, traits: [:with_ingredients, :with_procedures]
  end
end
