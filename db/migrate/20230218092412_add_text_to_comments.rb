class AddTextToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :text, :text
  end
end
