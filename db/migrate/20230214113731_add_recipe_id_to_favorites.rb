class AddRecipeIdToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_column :favorites, :recipe_id, :integer
  end
end
