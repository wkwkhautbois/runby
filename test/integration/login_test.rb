require "test_helper"

class LoginTest < ActionDispatch::IntegrationTest

  def setup
    @account = accounts(:person1) 
  end

  test "ログインしてトップ表示してログアウト" do
    # ログイン画面を表示
    get "/login"
    # ログインリンクが表示されていること
    assert_select "a[href=?]", "/login", 1

    # ログイン処理を実行(成功する)
    post "/login", params: {
      name: "person1",
      password: "foo",
    }
    # ログイン成功したらホームにリダイレクトされること
    assert_redirected_to "/"
    follow_redirect!
    # ログイン状態なのでログインボタンではなくログアウトリンク(POST)が表示されること
    assert_select "a[href=?]", "/login", 0
    assert_select "a[href=?]", "/logout", 1


    # ログアウト処理を実行
    delete "/logout"
    # ログアウト成功したらホームにリダイレクトされること
    assert_redirected_to "/"
    follow_redirect!
    # ログインリンクが表示されていること
    assert_select "a[href=?]", "/login", 1

  end
end
