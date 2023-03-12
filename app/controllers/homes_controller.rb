class HomesController < ApplicationController
  def top
    @q = Recipe.ransack(params[:q])
    @recipes = if params[:q].present?
                 @q.result(distinct: true).paginate(page: params[:page]).reverse_order
               else
                 Recipe.all.paginate(page: params[:page]).reverse_order
               end
  end

  def guest_sign_in
    guest_user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.password_confirmation = user.password
      user.name = "ゲスト"
      user.profile = "hello"
    end
    sign_in guest_user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end
