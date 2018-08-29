FactoryBot.define do
  factory :questions_answer do
    value { FFaker::Lorem.phrase }
    answer 
    question
  end
end
