require 'rails_helper'

RSpec.describe "レシピ機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { build(:recipe, user_id: user.id) }
  let!(:posted_recipe) { create(:recipe, :with_ingredients, :with_procedures, user_id: user.id) }

  before do
    sign_in user
  end

  describe '新規投稿機能', js: true do
    context 'フォームの入力値が正常' do
      it '正しく登録できること' do
        visit new_recipe_path
        attach_file "recipe[image]", Rails.root.join('test/fixtures/yakisoba.png'), make_visible: true
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        page.all(".ingredient_content")[0].set("材料1")
        page.all(".quantity_content")[0].set("分量1")
        click_link "作り方の追加"
        page.all(".procedure_content")[0].set("作り方1")
        expect { click_button '投稿' }.to change { Recipe.count }.by(1)
        expect(page).to have_selector("img[src$='png']", wait: 5)
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
        page.all(".ingredient_content")[0].set("材料1")
        page.all(".quantity_content")[0].set("分量1")
        click_link "作り方の追加"
        page.all(".procedure_content")[0].set("作り方1")
        click_button '投稿'
        expect(page).to have_content("レシピ名を入力してください")
        expect(page).to have_content("一言を入力してください")
      end

      it 'タイトルが31文字以上、一言が101文字以上の場合には登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: "a" * 31
        fill_in 'recipe_description', with: "a" * 101
        click_link "材料の追加"
        page.all(".ingredient_content")[0].set("材料1")
        page.all(".quantity_content")[0].set("分量1")
        click_link "作り方の追加"
        page.all(".procedure_content")[0].set("作り方1")
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
    end

    it '画像がない場合にはno_imageが表示されていること' do
      visit recipe_path(posted_recipe)
      expect(page).to have_selector("img[src*='no_image'][src$='.jpg']", wait: 5)
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
        visit recipe_path(posted_recipe)
        click_link "編集する"
        expect(current_path).to eq edit_recipe_path(posted_recipe)
        expect(page).to have_field 'recipe_title', with: recipe.title
        expect(page).to have_field 'recipe_description', with: recipe.description
        expect(page).to have_selector(".nested-fields .ingredient-fields", count: 1)
        expect(page).to have_css(".nested-fields .procedure-fields", count: 1)
        fill_in 'recipe_title', with: 'テストタイトル2'
        fill_in 'recipe_description', with: 'テストディスクリプション2'

        click_link "材料の追加"
        expect(page).to have_selector(".nested-fields .ingredient-fields", count: 2)
        page.all(".ingredient_content")[1].set("材料2")
        page.all(".quantity_content")[1].set("分量2")
        click_link "作り方の追加"
        expect(page).to have_selector(".nested-fields .procedure-fields", count: 2)
        page.all(".procedure_content")[1].set("作り方2")

        click_button '修正'
        expect(current_path).to eq recipe_path(posted_recipe)
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content("材料１")
        expect(page).to have_content("材料2")
        expect(page).to have_content("分量１")
        expect(page).to have_content("分量2")
        expect(page).to have_content("作り方１")
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
        expect(page).to have_content("一言を入力してください。")
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
      visit recipes_path
      expect(Recipe.count).to eq 0
    end
  end

  describe '一覧表示機能' do
    context '11件以上投稿がある' do
      let!(:recipes) do
        (1..11).map do |i|
          FactoryBot.create(:recipe, :with_ingredients, :with_procedures, user_id: user.id, title: "recipe_#{i}!")
        end
      end
      it '新しい投稿順にページネーションが正しく動作して、件数も正しいこと' do
        visit recipes_path
        expect(page).not_to have_content('recipe_1!')
        expect(page).to have_content("12件")
      end
    end
  end

  describe '検索機能' do
    context '検索内容が入力されている' do
      it 'like検索の検索結果が表示されていること' do
        visit recipes_path
        fill_in 'q_title_or_description_or_ingredients_ingredient_cont', with: posted_recipe.title[0..2]
        click_on '探す'
        expect(page).to have_content posted_recipe.title
      end

      it '該当がない場合には件数は0で何も表示されないこと' do
        visit recipes_path
        fill_in 'q_title_or_description_or_ingredients_ingredient_cont', with: 'non-existent recipe'
        click_on '探す'
        expect(page).to have_content '0件'
        expect(page).not_to have_content posted_recipe.title
      end
    end

    context '検索内容が入力されていない' do
      it '何も搾らずに全件表示されること' do
        visit recipes_path
        click_on '探す'
        expect(page).to have_content posted_recipe.title
      end
    end
  end
end
