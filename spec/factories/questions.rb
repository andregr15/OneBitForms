FactoryBot.define do
  factory :question do
    title { FFaker::Lorem.phrase }
    kind { [ 'short_text', 'long_text', 'integer', 'boolean' ].sample } # :short_text, :long_text, :integer, :boolean
    form
    required { FFaker::Boolean.maybe }
    order { rand(0..99) } 
  end
end
