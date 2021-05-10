module ExecutionsHelper

  # Executionの実行結果を表示用の文字列に変換する
  # @param [Execution] execution
  # @return 実行結果文字列
  def execution_result_to_string(execution)
    case execution.result
    when "success" then
      "正常終了"
    when "failure" then
      "異常終了"
    else
      "ステータス不明"
    end
  end
end
