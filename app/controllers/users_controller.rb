class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts_recipes = @user.recipes.order(created_at: :desc).limit(3)
    @favorites = @user.favorites.order(created_at: :desc).limit(3)
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = Recipe.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image)
  end
end
