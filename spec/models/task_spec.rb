require 'rails_helper'

RSpec.describe Task, type: :model do
  # バリデーションのテスト
  describe 'validation' do
    # 全てが有効
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
    
    # タイトルなしでは無効
    it 'is invalid without title' do
      task_without_title = build(:task, title: "") # タイトルがないタスクを作成
      expect(task_without_title).to be_invalid # 有効かチェック
      expect(task_without_title.errors[:title]).to eq ["can't be blank"]
    end

    # ステータスなしでは無効
    it 'is invalid without status' do
      task_without_status = build(:task, status: nil) # ステータスがないタスクを作成
      expect(task_without_status).to be_invalid # 有効かチェック
      expect(task_without_status.errors[:status]).to eq ["can't be blank"]
    end

    # 重複しているタイトルは無効
    it 'is invalid with a duplicate title' do
      task = create(:task) # 有効なタスクを作成
      task_with_duplicated_title = build(:task, title: task.title) # タイトルが重複するタスクを作成
      expect(task_with_duplicated_title).to be_invalid # ２個目のタスクが有効かチェック
      expect(task_with_duplicated_title.errors[:title]).to eq ["has already been taken"]
    end

    # 別のタイトルでは有効
    it 'is valid with another title' do
      task = create(:task) # 有効なタスク作成
      task_with_another_title = build(:task, title: 'another_title') # 別のタイトルを持つタスクを作成
      expect(task_with_another_title).to be_valid # ２個目のタスクが有効かチェック
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
