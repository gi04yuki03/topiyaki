class RemoveCommentFromComments < ActiveRecord::Migration[5.2]
  def change
    remove_column :comments, :comment, :text
  end
end
