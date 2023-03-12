require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'タイトル取得テスト' do
    it 'sub_titleが設定されていないときにBASE_TITLE(YAKITOPI)のみ取得できること' do
      expect(page_title('')).to eq 'YAKITOPI'
    end

    it 'sub_titleにsampleが設定されているときにsub_titleとBASE_TITLEが取得できること' do
      expect(page_title('sample')).to eq 'sample - YAKITOPI'
    end

    it 'sub_titleがnilのときにBASE_TITLE(YAKITOPI)のみ取得できること' do
      expect(page_title(nil)).to eq 'YAKITOPI'
    end
  end
end
