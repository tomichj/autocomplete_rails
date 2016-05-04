FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :first_name do |n|
    "FirstName#{n}"
  end

  sequence :last_name do |n|
    "LastName#{n}"
  end

  factory :user do
    email

    trait :with_full_name do
      first_name
      last_name
    end
  end
end
