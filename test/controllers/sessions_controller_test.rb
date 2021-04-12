require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ログイン成功でリダイレクト" do
    # ログイン処理を実行(成功する)
    post "/login", params: {
      name: "person1",
      password: "foo",
    }
    assert_redirected_to "/"
  end

  test "ログイン失敗ではリダイレクトせずにエラーメッセージ表示" do
    post "/login", params: {
      name: "person1",
      password: "xxxxx",
    }
    assert_response :success
    assert_select ".alert-danger", "アカウント名かパスワードが間違っています"
  end

  test "ログアウト状態でgetしたら画面を表示" do
    get "/login"
    assert_response :success
  end

  test "ログイン状態でgetしたらホーム画面へリダイレクト" do
    login_as "person1"
    get "/login"
    assert_redirected_to "/"
  end
end
