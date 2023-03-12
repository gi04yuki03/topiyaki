require 'rails_helper'

RSpec.describe "レシピお気に入り機能", type: :system, js:true do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: other_user.id) }
  let(:favorite) { user.favorites.create(recipe_id: recipe.id)}
  let!(:other_recipe) { create(:recipe, :with_ingredients, :with_procedures, user: other_user) }
  let(:destroy_favorite) { user.favorites.find_by(recipe_id: recipe.id).destroy }

  before do
    sign_in user
  end

  context 'お気に入り登録機能' do
    it 'お気に入り登録と解除ができる' do
      visit recipe_path(recipe)
      expect(page).to have_content('♡0')
      find('.favorite_btn').click
      expect(page).to have_content('♥1')
      expect(Favorite.count).to eq 1
      expect(user.favorites.first.recipe_id).to eq recipe.id
      expect(other_user.favorites.count).to eq 0
      find('.favorite_btn').click
      expect(page).to have_content('♡0')
      expect(Favorite.count).to eq 0
    end
  end

  describe 'お気に入りしたレシピ一覧' do
    context 'お気に入りしたレシピがない' do
      it 'お気に入りはありませんと表示されること' do
        visit user_path(user.id)
        expect(page).to have_content('のお気に入りはありません')
      end
    end

    context 'お気に入りしたレシピがある' do
      let!(:favorite_recipes) do
        (1..4).map do |i|
          recipe = FactoryBot.create(:recipe, :with_ingredients, :with_procedures, title: "favorite_recipe_#{i}", user: other_user)
          user.favorites.create(recipe: recipe)
          recipe
        end
      end
      it 'ユーザー詳細ページに3件まで表示できること' do
        visit user_path(user.id)
        within(".user-favorites") do
          expect(page).to have_selector('.user-favorites ul li', count: 3)
          expect(page).to have_content('favorite_recipe_4')
          expect(page).not_to have_content('favorite_recipe_1')
        end
      end

      it 'もっと見るを押すと正しく全件が表示されること' do
        visit user_path(user.id)
        click_link 'もっと見る'
        expect(current_path).to eq favorites_users_path
        expect(page).to have_selector('.index-list', count: 4)
        expect(page).to have_content('favorite_recipe_')
      end
    end
  end
end
