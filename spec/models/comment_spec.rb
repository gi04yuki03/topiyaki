require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }
  let(:comment) { build(:comment, recipe_id: recipe.id, user_id: user.id) }
  
  describe "正常系" do
    it '正しくコメントを投稿できること' do
      comment.valid?
      expect(comment.text).to eq('コメントです')
    end
  end

  describe "異常系" do
    context "未入力は投稿不可" do
      it '未入力の場合はコメントを投稿ができないこと' do
        comment = build(:comment, text: nil)
        comment.valid?
        expect(comment.errors[:text]).to include("を入力してください。")
      end
    end

    context "101文字以上は投稿不可" do
      it "101文字以上の場合はコメントを投稿ができないこと" do
        comment = build(:comment, text: "a" * 101)
        comment.valid?
        expect(comment.errors[:text]).to include("は100文字以内で入力してください。")
      end
    end
  end
end

