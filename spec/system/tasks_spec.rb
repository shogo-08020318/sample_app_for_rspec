require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  # ユーザーとタスク作成
  # @user = FactoryBot.create(:user) 以下は省略形
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe '画面遷移' do
      context 'タスク新規作成画面にアクセス' do
        it 'ログインしていないので失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required' # ログインが必要のメッセージ
          expect(current_path).to eq login_path # ログインが画面にリダイレクト
        end
      end
      context 'タスク一覧画面にアクセス' do
        it '全てのタスクが表示される' do
          task_list = create_list(:task, 3) # まとめて５個のデータを作成
          visit tasks_path
          expect(page).to  have_content task_list[0].title # それぞれのタイトルが表示されているか
          expect(page).to  have_content task_list[1].title
          expect(page).to  have_content task_list[2].title
          expect(current_path).to eq tasks_path
        end
      end
      context 'タスク詳細画面にアクセス' do
        it 'あるタスクの詳細が表示' do
          visit task_path(task) # letでローカル変数を定義
          expect(page).to have_content task.title
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タスク編集画面にアクセス' do
        it 'ログインしていないので失敗する' do
          visit edit_task_path(task)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'タスク新規作成' do
      context '入力項目が有効' do
        it 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in "Title", with: 'test_title'
          fill_in "Content", with: 'test_content'
          # select'option value' from: 'select locator')
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2021, 3, 10, 12, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Title: test_title'
          expect(page).to have_content 'Content: test_content'
          expect(page).to have_content 'Status: doing'
          expect(page).to have_content 'Deadline: 2021/3/10 12:30'
          expect(page).to have_content 'Task was successfully created.'
          expect(current_path).to eq '/tasks/1'
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの新規作成に失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end

      context '重複しているタイトルを入力' do
        it 'タスクの新規作成が失敗する' do
          visit new_task_path
          test_task = create(:task) # あるタスクを作成
          fill_in 'Title', with: test_task.title # 上記のタイトルと同じものを作成
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq tasks_path
        end
      end
      # ステータス無効のテストは不要？
    end

    describe 'タスク編集' do
      # 編集前のデータを作成
      let(:task) { create(:task, user: user) }
      let(:test_task) { create(:task, user: user) } # 重複のテスト用

      context '入力項目が有効' do
        it 'タスクの編集が完了する' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update_title'
          select 'done', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title: update_title'
          expect(page).to have_content 'Status: done'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end

      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end

      context '重複しているタイトルを入力' do
        it 'タスクの編集が失敗する' do
          visit edit_task_path(task)
          fill_in 'Title', with: test_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
    end
    
    describe 'タスク削除' do
      # 削除対象のタスク作成
      let!(:task) { create(:task, user: user) }

      it 'タスクの削除に成功する' do
        visit tasks_path # 一覧画面にアクセス
        click_link 'Destroy' # 削除リンククリック
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'Task was successfully destroyed.'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title #タスク(のタイトル)がないことを確認
      end    
    end
  end
end
