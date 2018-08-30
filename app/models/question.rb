class Question < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy
  validates :title, :kind, :form, presence: true
  enum kind: [ :short_text, :long_text, :integer, :boolean ]
end
