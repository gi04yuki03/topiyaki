require 'rails_helper'

RSpec.describe "レシピ機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { build(:recipe, user_id: user.id) }
  let(:posted_recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }

  before do
    sign_in user
  end

  describe '新規投稿機能', js: true do
    context 'フォームの入力値が正常' do
      it '正しく登録できること' do
        visit new_recipe_path
        attach_file "recipe[image]", "#{Rails.root}/test/fixtures/yakisoba.png", make_visible: true
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        fill_in 'recipe_ingredients_attributes_0_ingredient', with: "材料1"
        fill_in 'recipe_ingredients_attributes_0_quantity', with: "分量1"
        click_link "作り方の追加"
        fill_in 'recipe_procedures_attributes_0_procedure', with: "作り方1"
        expect {click_button '投稿'}.to change {Recipe.count}.by(1)
        expect(page).to have_selector("img[src$='yakisoba.jpeg']")
        expect(page).to have_content("材料1")
        expect(page).to have_content("分量1")
        expect(page).to have_content("作り方1")
      end
    end

    context 'フォームの入力値が異常' do
      it 'タイトル、一言が未入力の場合には登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: nil
        fill_in 'recipe_description', with: nil
        click_link "材料の追加"
        fill_in 'recipe_ingredients_attributes_0_ingredient', with: "材料1"
        fill_in 'recipe_ingredients_attributes_0_quantity', with: "分量1"
        click_link "作り方の追加"
        fill_in 'recipe_procedures_attributes_0_procedure', with: "作り方1"
        click_button '投稿'
        expect(page).to have_content("レシピ名を入力してください")
        expect(page).to have_content("一言を入力してください")
      end

      it 'タイトルが31文字以上、一言が101文字以上の場合には登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with:  "a" * 31
        fill_in 'recipe_description', with:  "a" * 101
        click_link "材料の追加"
        fill_in 'recipe_ingredients_attributes_0_ingredient', with: "材料1"
        fill_in 'recipe_ingredients_attributes_0_quantity', with: "分量1"
        click_link "作り方の追加"
        fill_in 'recipe_procedures_attributes_0_procedure', with: "作り方1"
        click_button '投稿'
        expect(page).to have_content("レシピ名は30文字以内で入力してください。")
        expect(page).to have_content("一言は100文字以内で入力してください。")
      end

      it '材料、作り方が未入力の場合には登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_button '投稿'
        expect(page).to have_content("材料は1つ以上登録してください。")
        expect(page).to have_content("作り方は1つ以上登録してください。")
      end
    end
  end

  describe '詳細ページ表示機能' do
    it '投稿されているレシピを正しく表示できていること' do
      visit recipe_path(posted_recipe)
      expect(page).to have_content(posted_recipe.title)
      expect(page).to have_content(posted_recipe.description)
      expect(page).to have_content("材料１")
      expect(page).to have_content("分量１")
      expect(page).to have_content("作り方１")
    end

    it '画像がない場合にはno_imageが表示されていること' do
      expect(page).to have_selector("img[src$='no_image.jpg']")
    end

    it '他のユーザーの投稿には削除・編集ボタンがないこと' do
      sign_in other_user
      visit recipe_path(posted_recipe)
      expect(page).to_not have_content("編集")
      expect(page).to_not have_content("削除")
    end
  end

  describe '編集機能', js: true do
    context 'フォームの入力値が正常' do
      it '正しく修正できること' do
        visit edit_recipe_path(posted_recipe)
        expect(page).to have_field 'recipe_title', with: recipe.title
        expect(page).to have_field 'recipe_description', with: recipe.description
        fill_in 'recipe_title', with: 'テストタイトル2'
        fill_in 'recipe_description', with: 'テストディスクリプション2'
        click_link "材料の追加"
        #2つ目の要素に登録
        page.all(".ingredient_content")[1].set("材料2")
        page.all(".quantity_content")[1].set("分量2")
        click_link "作り方の追加"
        #2つ目の要素に登録
        page.all(".procedure_content")[1].set("作り方2")
        click_button '修正'
        expect(current_path).to eq recipe_path(posted_recipe)
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content("材料1")
        expect(page).to have_content("材料2")
        expect(page).to have_content("分量1")
        expect(page).to have_content("分量2")
        expect(page).to have_content("作り方1")
        expect(page).to have_content("作り方2")
      end
    end

    context 'フォームの入力値が異常' do
      it 'タイトル、一言が未入力の場合には登録不可' do
        visit edit_recipe_path(posted_recipe)
        expect(page).to have_field 'recipe_title', with: recipe.title
        expect(page).to have_field 'recipe_description', with: recipe.description
        fill_in 'recipe_title', with: nil
        fill_in 'recipe_description', with: nil
        click_button '修正'
        expect(page).to have_content("レシピ名を入力してください。")
        expect(page).to have_content("言を入力してください。")
      end

      it '材料、作り方が未入力の場合には登録不可' do
        visit edit_recipe_path(posted_recipe)
        find(".ingredient_content").set(nil)
        find(".quantity_content").set(nil)
        find(".procedure_content").set(nil)
        click_button '修正'
        expect(current_path).to eq edit_recipe_path(posted_recipe)
        expect(page).to have_content("材料名を入力してください")
        expect(page).to have_content("作り方を入力してください")
      end
    end
  end

  describe '削除機能' do
    it '正しく投稿を削除できること' do
      visit recipe_path(posted_recipe)
      expect(Recipe.count).to eq 1
      click_link '削除'
      expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか？"
      page.driver.browser.switch_to.alert.accept
      expect(Recipe.count).to eq 0
    end
  end

  describe '一覧表示機能' do
    context '11件以上投稿がある' do
      before do
        let(:recipes) { create_list(:recipe, 11, :with_ingredients, :with_procedures, user_id: user.id) }
      end
      it '新しい投稿順にページネーションが正しく動作して、件数も正しいこと' do
        visit recipes_path
        expect(page).not_to have_content("posted_recipe_0")
        expect(page).to have_content("11件")
      end
    end
  end

  #describe '検索機能' do
    #context '検索内容が入力されている' do
      #it 'like検索の検索結果が表示されていること' do

      #end

      #it '該当がない場合には件数は0で何も表示されないこと' do

      #end 
    #end

    #context '検索内容が入力されていない' do
      #it '何も搾らずに全件表示されること' do

      #end
    #end
  #end
end



