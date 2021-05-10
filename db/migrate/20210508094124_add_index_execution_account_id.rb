class AddIndexExecutionAccountId < ActiveRecord::Migration[6.1]
  def change
    add_index :executions, :account_id
  end
end
