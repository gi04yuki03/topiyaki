class FavoritesController < ApplicationController
  def index
    @favorites = Favorite.where(user_id: @user.id).all
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.new(recipe_id: recipe.id)
    favorite.save
    redirect_to recipe_path(recipe)
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe_id: recipe.id)
    favorite.destroy
    redirect_to recipe_path(recipe)
  end
end
