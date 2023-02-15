class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipe_path(@recipe.id)
    else
      render "new"
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if recipe.update(recipe_params)
      flash[:notice] = "情報を更新しました"
      redirect_to recipe_path(recipe.id)
    else
      render "/edit"
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to :recipes
  end

  
  private
  def recipe_params
    params.require(:recipe).permit(:title, :description, :image).merge(user_id:current_user.id)
  end
end
