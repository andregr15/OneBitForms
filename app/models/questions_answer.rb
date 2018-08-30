class QuestionsAnswer < ApplicationRecord
  belongs_to :answer
  belongs_to :question
  validates :answer, :question, presence: true
end
