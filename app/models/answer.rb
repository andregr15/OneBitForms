class Answer < ApplicationRecord
  belongs_to :form
  has_many :questions_answers, dependent: :destroy
  accepts_nested_attributes_for :questions_answers

  validates :form, presence: true

  def self.create_with_questions_answers(form, questions_answers)
    answer = nil
    
    ActiveRecord::Base.transaction do
      answer = Answer.create(form: form)
      questions_answers.each do |qa|
        answer.questions_answers.create(qa.permit(:question_id, :value))
      end
    end
    answer
  end
end
