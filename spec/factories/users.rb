FactoryGirl.define do
  factory :user do
    sequence(:email) do |n|
      "test-#{n}@example.com"
    end
    password '12345678'
    password_confirmation '12345678'
  end
end
