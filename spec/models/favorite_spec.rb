require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }
  let(:comment) { build(:comment, recipe_id: recipe.id, user_id: user.id) }
  let(:favorite) { user.favorites.create(recipe_id: recipe.id) }
  let(:destroy_favorite) { user.favorites.find_by(recipe_id: recipe.id).destroy }

  it "レシピにいいね可能" do
    expect(favorite.user.name).to eq "テストユーザー名"
    expect(favorite.recipe.title).to eq "テストタイトル"
    expect(user.favorites.count).to eq 1
  end

  it "いいね済みであれば「いいね」解除可能" do
    expect { favorite }.to change { Favorite.count }.by(1)
    expect { destroy_favorite }.to change { Favorite.count }.by(-1)
    expect(user.favorites.count).to eq 0
  end
end
