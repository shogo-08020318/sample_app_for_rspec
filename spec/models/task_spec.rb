require 'rails_helper'

RSpec.describe Task, type: :model do
  # バリデーションのテスト
  describe 'validation' do
    # 全てが有効
    it 'is valid with all attributes' do
      user = FactoryBot.build(:user)
      expect(FactoryBot.build(:task, user: user)).to be_valid
    end

    # タイトルなしでは無効
    it 'is invalid without title' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    # ステータスなしでは無効
    it 'is invalid without status' do
      user = FactoryBot.build(:user)
      task = FactoryBot.build(:task, status: nil, user: user)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    # 重複しているタイトルは無効
    it 'is invalid with a duplicate title' do
      user = FactoryBot.build(:user)
      FactoryBot.create(:task, title: 'title', user: user)
      task = FactoryBot.build(:task, title: 'title', user: user)
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    # 別のタイトルでは有効
    it 'is valid with another title' do
      user = FactoryBot.build(:user)
      base_task = FactoryBot.create(:task, title: 'title', user: user)
      other_task = FactoryBot.build(:task, title: 'titletitle', user: user)
      expect(other_task).not_to be base_task
    end
  end
end
