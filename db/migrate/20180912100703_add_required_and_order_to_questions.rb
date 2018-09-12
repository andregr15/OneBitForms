class AddRequiredAndOrderToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :required, :boolean
    add_column :questions, :order, :integer
  end
end
