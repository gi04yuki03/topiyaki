class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    recipe = Recipe.new(recipe_params)
    recipe.save
    redirect_to recipe_path(recipe.id)
  end

  private
  def recipe_params
    params.require(:recipe).permit(:title, :description, :image)
  end
end
