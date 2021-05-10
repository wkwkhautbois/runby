class AddAccountForeignKeyToExecutions < ActiveRecord::Migration[6.1]
  def up
    add_foreign_key :executions, :accounts
  end

  def down
    remove_foreign_key :executions, :accounts
  end
end
