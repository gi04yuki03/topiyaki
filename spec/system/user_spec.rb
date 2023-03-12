require 'rails_helper'

RSpec.describe "ユーザー編集", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:other_recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: other_user.id) }
  let(:guest_user) { User.guest }

  before do
    sign_in user
  end

  describe '編集機能' do
    context 'フォームの入力値が正常' do
      it '正しく修正できること' do
        visit user_path(user.id)
        within(".user-right") do
          click_link 'プロフィールを編集する'
        end
        expect(current_path).to eq edit_user_path(user.id)     
        fill_in 'user_name', with: 'Sample'
        fill_in 'user_profile', with: "Sample_profile"
        attach_file 'user_profile_image', "#{Rails.root}/test/fixtures/yakisoba.png", make_visible: true
        click_button '更新'
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content('ユーザー情報を更新しました')
        expect(page).to have_selector("img[src$='.png']")
        expect(page).to have_content('Sample')
        expect(page).to have_content('Sample_profile')
      end
    end

    context 'フォームの入力値が正常' do
      it 'ユーザー名、プロフィールが未入力の場合には登録不可' do
        visit user_path(user.id)
        within(".user-right") do
          click_link 'プロフィールを編集する'
        end
        fill_in 'user_name', with: nil
        fill_in 'user_profile', with: nil
        click_button '更新'
        expect(page).to have_content('ユーザー名を入力してください')
        expect(page).to have_content('自己紹介を入力してください')
      end
    end
  end

  describe '投稿したレシピ一覧' do
    context '投稿したレシピがない' do
      it '投稿はありませんと表示されること' do
        visit user_path(user.id)
        expect(page).to have_content('の投稿はありません')
      end
    end

    context '投稿したレシピがある' do
      let!(:posted_recipes) do
        (1..4).map do |i|
          FactoryBot.create(:recipe, :with_ingredients, :with_procedures, title: "posted_recipe_#{i}", user: user)
        end
      end
            
      it '詳細ページに3件まで表示できること' do
        visit user_path(user.id)
        within(".user-posted") do
          expect(page).to have_selector('.user-posted ul li', count: 3)
          expect(page).to have_content('posted_recipe_4')
          expect(page).not_to have_content('posted_recipe_1')
        end
      end

      it 'もっと見るを押すと正しく全件が表示されること' , js: true do
        visit user_path(user.id)
        click_link 'もっと見る'
        expect(current_path).to eq posted_users_path
        expect(page).to have_selector('.index-list', count: 4)
        expect(page).to have_content('posted_recipe_1')
      end 
    end
  end

  describe 'ゲストログイン機能' do
    it 'ゲストユーザーとしてログインできること' do
      visit root_path
      click_link 'ゲストログイン（閲覧用）'
      visit user_path(guest_user.id)
    end
  end

  describe '削除機能' do
    it '正しくアカウントを削除できること' do
      visit user_path(user)
      click_link 'アカウントを削除する'
      expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか？"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content('アカウントを削除しました')
    end
  end
end
