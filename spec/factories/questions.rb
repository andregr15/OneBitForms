FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.phrase }
    kind { rand(0..3) } # :short_text, :long_text, :integer, :boolean
    form 
  end
end
