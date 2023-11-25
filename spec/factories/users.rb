FactoryBot.define do
  factory :user do
    email { "example@gmail.com" }
    password { "password" }
    jti { "66c8da4f-a981-4916-8d57-9ced382e5d23" }
  end
end
