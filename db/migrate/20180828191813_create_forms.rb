class CreateForms < ActiveRecord::Migration[5.2]
  def change
    create_table :forms do |t|
      t.string :title
      t.text :description
      t.references :user, foreign_key: true
      t.string :primary_color
      t.boolean :enable

      t.timestamps
    end
  end
end
