FactoryBot.define do
  factory :user do
    name                  { "テストユーザー名" }
    email                 { "test@test.com" }
    password              { "111111" }
    password_confirmation { "111111" }

    factory :other_user do
      name                  { "ほかのユーザー名" }
      email                 { "other@test.com" }
      password              { "222222" }
      password_confirmation { "222222" }
    end
  end
end
