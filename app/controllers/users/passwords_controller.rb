# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_normal_user, only: :create

  def ensure_normal_user
    redirect_to new_user_session_path, alert: 'ゲストユーザーのパスワード再設定はできません。' if params[:user][:email].casecmp('guest@example.com').zero?
  end
end
