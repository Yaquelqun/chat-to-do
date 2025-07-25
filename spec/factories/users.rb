# Factory for User model
# Corresponding tests: spec/models/user_spec.rb

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    pseudo { Faker::Internet.username(specifier: 5..15) }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
  end
end
