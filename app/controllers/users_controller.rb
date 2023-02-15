class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts_recipes = @user.recipes.order(created_at: :desc).limit(3)
    @favorites = @user.favorites.order(created_at: :desc).limit(3)
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to user_path(@user.id)
    else
      render "edit"
    end
  end

  def posted
    @user = current_user
    @recipes = @user.recipes
  end

  def favorites
    @user = current_user
    favorites = Favorite.where(user_id: @user.id).pluck(:recipe_id)
    @recipes = Recipe.find(favorites)
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
