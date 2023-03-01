class CommentsController < ApplicationController
  def create
    recipe = Recipe.find(params[:recipe_id])
    comment = current_user.comments.new(comment_params)
    comment.recipe_id = recipe.id
    if comment.save
      flash[:notice] = "コメントを投稿しました"
      redirect_to recipe_path(recipe)
    else
      redirect_to recipe_path(recipe)    
    end
    
  end

  def destroy
    Comment.find_by(id: params[:id], recipe_id: params[:recipe_id]).destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to recipe_path(params[:recipe_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
