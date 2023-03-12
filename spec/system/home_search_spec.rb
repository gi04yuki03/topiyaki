require 'rails_helper'

RSpec.describe "トップページからの検索機能", type: :system do
  let(:user) { create(:user) }
  let!(:posted_recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }

  context '検索内容が入力されている' do
    it 'like検索の検索結果が表示されていること' do
      visit root_path
      fill_in 'q_title_or_description_or_ingredients_ingredient_cont', with: posted_recipe.title[0..2]
      find('.search-icon').click
      expect(page).to have_content posted_recipe.title
    end

    it '該当がない場合には件数は0で何も表示されないこと' do
      visit root_path
      fill_in 'q_title_or_description_or_ingredients_ingredient_cont', with: 'non-existent recipe'
      find('.search-icon').click
      expect(page).to have_content '0件'
      expect(page).not_to have_content posted_recipe.title
    end
  end

  context '検索内容が入力されていない' do
    it '何も搾らずに全件表示されること' do
      visit root_path
      find('.search-icon').click
      expect(page).to have_content posted_recipe.title
    end
  end
end
