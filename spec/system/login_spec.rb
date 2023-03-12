require 'rails_helper'

RSpec.describe "ユーザーログイン", type: :system do
  let(:user) { create(:user) }

  describe '通常ユーザーログイン' do
    context 'フォームの入力値が正常' do
      it '正確な情報を入力したらログイン可能。そしてトップへ' do
        visit new_user_session_path
        expect(page).to have_content('ログイン')
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq root_path
        expect(page).to have_content('ログインしました。')
      end
    end

    context 'フォームの入力値が異常のためログイン不可' do
      it 'メールアドレスが誤っているため再度ログインページへ' do
        visit new_user_session_path
        expect(page).to have_content('ログイン')
        fill_in 'user_email', with: "sample@example.com"
        fill_in 'user_password', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq new_user_session_path
      end

      it 'パスワードが誤っているため再度ログインページへ' do
        visit new_user_session_path
        expect(page).to have_content('ログイン')
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: "Example123"
        click_button 'ログイン'
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
