require 'rails_helper'

RSpec.describe "レシピいいね機能", type: :system, js:true do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: other_user.id) }
  let(:favorite) { user.favorites.create(recipe_id: recipe.id)}
  let!(:other_recipe) { create(:recipe, :with_ingredients, :with_procedures, user: other_user) }
  let(:destroy_favorite) { user.favorites.find_by(recipe_id: recipe.id).destroy }

  before do
    sign_in user
  end

  context 'いいね確認' do
    it 'リンクが諸々正しい' do
      expect(page).to have_link '', href: recipe_favorite_path(recipe) #リンクが正しい
      expect(page).to have_css('i.far') #いいねの表示
      expect(page).to have_css('i.fas') #いいね済の表示
    end
  end

  describe 'お気に入りしたレシピ一覧' do
    context 'お気に入りしたレシピがある' do
      it '詳細ページに3件まで表示できること' do

      end

      it 'もっと見るを押すと正しく全件が表示されること' do

      end
    end

    context 'お気に入りしたレシピがない' do
      it 'レシピが表示されないこと' do

      end
    end
  end
end
