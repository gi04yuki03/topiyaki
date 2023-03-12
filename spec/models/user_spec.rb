require 'rails_helper'

RSpec.describe User, type: :model do
  describe "正常系" do
    it "正しく登録できること" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe "異常系" do
    context "必須入力であること" do
      it "name、email、passwordは必須であること" do
        is_expected.to validate_presence_of :name
        is_expected.to validate_presence_of :email
        is_expected.to validate_presence_of :password
      end
    end
    it "nameが11文字以上であれば登録できないこと" do
      user = build(:user, name: '1234567891011')
      user.valid?
      expect(user.errors.full_messages.first).to eq("ユーザー名は10文字以内で入力してください。")
    end
    it "passwordは6文字未満、password_confirmationと一致しない場合には登録できないこと" do
      user = build(:user, password: '12345')
      user.valid?
      expect(user.errors.full_messages.first).to eq("パスワード(確認)とパスワードの入力が一致しません。")
      expect(user.errors.full_messages.second).to eq("パスワードは6文字以上で入力してください。")
    end
  end
end
