require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  let(:user) { build(:user) }

  describe '正常' do
    context 'フォームの入力値が正常' do
      it '正確な情報を入力したら登録可能' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation
        expect { click_button '新しいアカウントを作成' }.to change { User.count }.by(1)

        expect(current_path).to eq new_user_session_path
        expect(page).to have_content('ようこそ！アカウント登録を受け付けました。')
      end
    end
  end

  describe '異常' do
    context 'フォームの入力値が異常のため登録不可' do
      it 'メールアドレスが入っていないため再度登録ページへ' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: nil
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation

        expect { click_button '新しいアカウントを作成' }.to change { User.count }.by(0)

        expect(current_path).to eq users_path
        expect(page).to have_content('Eメールを入力してください')
      end

      it 'パスワード入力条件を満たしていないため再度登録ページへ' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: "password"
        fill_in 'user_password_confirmation', with: "password"

        expect { click_button '新しいアカウントを作成' }.to change { User.count }.by(0)
        expect(ActionMailer::Base.deliveries.size).to eq 0
        expect(current_path).to eq users_path
        expect(page).to have_content('パスワードは半角6~20文字英大文字・小文字・数字それぞれ1文字以上含む必要があります')
        expect(page).to have_content('パスワード（確認用）は半角6~20文字英大文字・小文字・数字それぞれ1文字以上含む必要があります')
      end
    end
  end

end
