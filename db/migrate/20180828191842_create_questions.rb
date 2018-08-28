class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :title
      t.integer :kind
      t.references :form, foreign_key: true

      t.timestamps
    end
  end
end
