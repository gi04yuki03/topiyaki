require 'rails_helper'

RSpec.describe Comment, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }
  let(:comment) { create(:comment, recipe_id: recipe.id, user_id: user.id) }
  let!(:posted_comment) { create(:comment, recipe_id: recipe.id, user_id: user.id) }

  before do
    sign_in user
  end

  describe 'コメント投稿機能' do
    context '投稿内容が異常の場合' do
      it '未入力の場合は投稿されないこと' do
        visit recipe_path(recipe)
        expect(page).to have_content(recipe.title)
        fill_in 'comment_text', with: ''
        click_button '送信する'
        expect(page).to have_content("コメントを入力してください")
      end

      it '101文字異常の場合は投稿されないこと' do
        visit recipe_path(recipe)
        fill_in "comment_text", with: "a" * 101
        click_button '送信する'
        expect(page).to have_content("コメントは100文字以内で入力してください。")
      end
    end
    context '正しい投稿内容の場合'do
      it '正常に登録されること' do
        visit recipe_path(recipe)
        fill_in "comment_text", with: comment.text
        click_button '送信する'
        expect(current_path). to eq recipe_path(recipe)
        expect(page).to have_content("コメントを投稿しました")
        expect(page).to have_content(comment.text)
      end
    end
  end

  describe 'コメント表示機能' do
    it '誰でも閲覧可能なこと' do
      posted_comment
      visit recipe_path(recipe)
      expect(page).to have_content(posted_comment.text)
    end

    it 'コメントを投稿した本人であれば削除ボタンが表示されること' do
      posted_comment
      visit recipe_path(recipe)
      expect(page).to have_content(posted_comment.text)
      expect(page).to have_link('削除')
    end

    it '他のユーザーが投稿したコメントには削除ボタンが表示されないこと' do
      sign_in other_user
      posted_comment
      visit recipe_path(recipe)
      expect(page).to have_content(posted_comment.text)
      expect(page).to have_no_link('削除')
    end

    it "ログインしていない場合はコメント投稿フォームが表示されないこと" do
      sign_out user
      visit recipe_path(recipe)
      expect(page).to have_no_button('送信する')
    end
  end

  describe 'コメント削除機能' do
    it 'コメントを投稿した本人であれば削除ボタンからコメントの削除ができること', js: true do
      posted_comment
      visit recipe_path(recipe)
      click_link '削除'
      expect(page).to have_content 'コメントを削除しました'
      expect(page).to_not have_content(posted_comment.text)
    end
  end
end
