class CreateQuestionsAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :questions_answers do |t|
      t.text :value
      t.references :answer, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
