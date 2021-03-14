module TestLogin
  def login_as(user)
    # トップページにアクセス
    visit root_path
    # ログインリンクをクリック
    click_link "Login"
    # ログインフォームに入力
    fill_in "Email", with: user.email
    fill_in "Password", with: 'password'
    # ログインボタンをクリック
    click_button "Login"
  end
end