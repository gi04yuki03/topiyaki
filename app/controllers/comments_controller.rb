class CommentsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = Comment.new(comment_params)
    @comment.recipe_id = @recipe.id
    if @comment.save
      redirect_to recipe_path(@recipe), notice: "コメントを投稿しました"
    else
      flash.now[:alert] = "コメントの投稿に失敗しました"
      @comments = @recipe.comments
      render 'recipes/show'
    end
  end

  def destroy
    Comment.find_by(id: params[:id], recipe_id: params[:recipe_id]).destroy
    flash[:notice] = "コメントを削除しました"
    redirect_to recipe_path(params[:recipe_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end
end
