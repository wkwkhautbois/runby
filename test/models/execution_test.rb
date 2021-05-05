require "test_helper"

class ExecutionTest < ActiveSupport::TestCase
  setup do
    @execution = Execution.new
    @execution.account_id = 1
    @execution.program = "a"
    @execution.input = ""
    @execution.output = ""
    @execution.result = 0
  end

  test "プログラム: 空文字はNG" do
    @execution.program = ""
    assert_not @execution.valid?
  end

  test "プログラム: 1文字はOK" do
    @execution.program = "a" * 1
    assert @execution.valid?
  end

  test "プログラム: 8000文字はOK" do
    @execution.program = "a" * 8000
    assert @execution.valid?
  end

  test "プログラム: 8001文字はNG" do
    @execution.program = "a" * 8001
    assert_not @execution.valid?
  end

  test "プログラム: 全角でも8000文字はOK" do
    @execution.program = "あ" * 8000
    assert @execution.valid?
  end

  test "入力: 空文字はOK" do
    @execution.input = ""
    assert @execution.valid?
  end

  test "入力: 1文字はOK" do
    @execution.input = "a" * 1
    assert @execution.valid?
  end

  test "入力: 1000文字はOK" do
    @execution.input = "a" * 1000
    assert @execution.valid?
  end

  test "入力: 1001文字はNG" do
    @execution.input = "a" * 1001
    assert_not @execution.valid?
  end

  test "入力: 全角でも1000文字はOK" do
    @execution.input = "あ" * 1000
    assert @execution.valid?
  end

end
