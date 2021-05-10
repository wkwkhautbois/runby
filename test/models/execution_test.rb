require "test_helper"

class ExecutionTest
  def self.create_instance
    execution = Execution.new
    execution.account_id = 1
    execution.program = "a"
    execution.input = "b"
    #execution.output = ""
    #execution.result = 0
    execution
  end

  class ValidationTest < ActiveSupport::TestCase
    setup do
      @execution = ExecutionTest.create_instance
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

    test "[内部] 存在しないアカウントではエラー" do
      @execution.account_id = 99999
      assert_not @execution.valid?
    end
  end

  class LogicTest < ActiveSupport::TestCase
    setup do
      @execution = ExecutionTest.create_instance
    end

    teardown do
      Faraday.default_connection = nil
    end

    test "プログラム実行のAPIリクエスト値と成功時のDB登録値のテスト" do
      program = "abc"
      input = "def"

      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/execution") do |env|
          #noinspection RubyResolve
          assert_equal env.request_body[:program], program
          #noinspection RubyResolve
          assert_equal env.request_body[:input], input

          [
            200,
            {},
            {
              "result" => "success",
              "output" => "xyz",
            }
          ]
        end
      end

      conn = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      @execution.stub(:connection, conn) do
        @execution.program = program
        @execution.input = input
        @execution.save

        stubs.verify_stubbed_calls
        assert_equal "xyz", @execution.output
        assert_equal "success", @execution.result
      end
    end


    test "プログラム実行失敗時の登録値のテスト" do
      stubs = Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post("/execution") do
          [
            200,
            {},
            {
              "result" => "failure",
              "output"=> "fff",
            }
          ]
        end
      end

      conn = Faraday.new do |builder|
        builder.adapter :test, stubs
      end

      @execution.stub(:connection, conn) do
        @execution.program = "abc"
        @execution.input = "ijk"
        @execution.save

        stubs.verify_stubbed_calls
        assert_equal "fff", @execution.output
        assert_equal "failure", @execution.result
      end
    end
  end
end
