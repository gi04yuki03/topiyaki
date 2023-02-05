class AddImageIdToRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :image_id, :string
  end
end
