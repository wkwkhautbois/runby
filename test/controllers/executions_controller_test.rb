require "test_helper"

class ExecutionsControllerTest < ActionDispatch::IntegrationTest

  test "実行結果一覧画面を表示できること" do
    login_as("person1")
    get executions_url
    assert_response :success
  end

  test "新規プログラム実行画面を表示できること" do
    login_as("person1")
    get new_execution_url
    assert_response :success
  end

  test "プログラム実行結果画面を表示できること" do
    login_as("person1")
    get execution_url(1)
    assert_response :success
  end

  test "プログラム実行処理で実行結果の登録に成功すること" do
    login_as "person1"

    stub_request(:post, "localhost:8080/execution").to_return(
      status: 200,
      body: { result: "success", output: "xyz" }.to_json
    )

    # 登録処理によって件数が1増えること
    assert_difference('Execution.count') do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end

    # 実行結果詳細表示画面にリダイレクトされること
    assert_redirected_to execution_url(Execution.last)
  end

  test "プログラム実行処理ではログインユーザーのアカウントIDで登録されること" do
    stub_request(:post, "localhost:8080/execution").to_return(
      status: 200,
      body: { result: "success", output: "xyz" }.to_json
    )

    login_as "person1"
    assert_difference('Execution.where(account_id: Account.find_by(name: "person1").id).count') do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end

    login_as "person2"
    assert_difference('Execution.where(account_id: Account.find_by(name: "person2").id).count') do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end
  end

  test "ログアウト状態でプログラム実行画面を表示するとログイン画面にリダイレクトされること" do
    get new_execution_url
    assert_redirected_to login_url
  end

  test "ログアウト状態で実行処理を実行すると登録されずにログイン画面にリダイレクトされること" do
    assert_no_difference('Execution.where(account_id: Account.find_by(name: "person1").id).count') do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end
    assert_redirected_to login_url
  end

  test "プログラム実行APIとの通信エラー(400)でraiseすること" do
    login_as "person1"

    stub_request(:post, "localhost:8080/execution").to_return(status: 400)
    assert_raises Faraday::Error do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end
  end

  test "プログラム実行APIとの通信エラー(500)でraiseすること" do
    login_as "person1"

    stub_request(:post, "localhost:8080/execution").to_return(status: 500)
    assert_raises Faraday::Error do
      post executions_url, params: { execution: { program: 'p "hello"', input: "" } }
    end
  end

  # test "should show execution" do
  #   get execution_url(@execution)
  #   assert_response :success
  # end
  #
  # test "should destroy execution" do
  #   assert_difference('Execution.count', -1) do
  #     delete execution_url(@execution)
  #   end
  #
  #   assert_redirected_to executions_url
  # end

end
