require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { build(:recipe, user_id: user.id) }

  describe "正常系" do
    it "正しく投稿できること" do
      ingredient = Ingredient.new(ingredient: "材料1", quantity: "分量1")
      procedure = Procedure.new(procedure: "ステップ1")
      recipe.save

      expect(recipe.title).to eq('テストタイトル')
      expect(recipe.description).to eq('テストディスクリプション')
      expect{recipe.ingredients << ingredient}.to change{recipe.ingredients.to_a}.from([]).to([ingredient])
      expect{recipe.procedures << procedure}.to change{recipe.procedures.to_a}.from([]).to([procedure])

      expect(recipe).to be_valid
    end
  end
  
  describe "異常系" do
    context "必須入力であること" do
      it "レシピのタイトルと説明は必須であること" do
        is_expected.to validate_presence_of :title
        is_expected.to validate_presence_of :description
      end

      it "材料と作り方は必須であること" do
        recipe.save
        recipe.valid?
        expect(recipe.errors.full_messages.first).to eq("材料は1つ以上登録してください。")
        expect(recipe.errors.full_messages.second).to eq("作り方は1つ以上登録してください。")
      end
    end

    context "文字数制限" do
      it "レシピのタイトルは30文字以内であること" do
        recipe = build(:recipe, title: "a" * 31)
        recipe.save
        recipe.valid?
        expect(recipe.errors[:title]).to include("は30文字以内で入力してください。")
      end

      it "レシピの説明は100文字以内であること" do
        recipe = build(:recipe, description: "a" * 101)
        recipe.save
        recipe.valid?
        expect(recipe.errors[:description]).to include("は100文字以内で入力してください。")
      end
    end
  end
end
