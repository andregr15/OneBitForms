class RemoveUserIdFromAnswer < ActiveRecord::Migration[5.2]
  def change
    remove_column :answers, :user_id, :integer
  end
end
