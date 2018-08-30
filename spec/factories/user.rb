FactoryBot.define do
  factory :user do
    uid          { FFaker::Lorem.word }
    email        { FFaker::Internet.email }
    name         { FFaker::Name.name }
    nickname     { FFaker::Internet.user_name }
    password     { FFaker::Internet.password }
    provider     'email'
    confirmed_at { FFaker::Time.between(1.months.ago, Date.today) }
    created_at   { FFaker::Time.between(1.months.ago, Date.today) }
    updated_at   { FFaker::Time.between(1.months.ago, Date.today) }
  end
end