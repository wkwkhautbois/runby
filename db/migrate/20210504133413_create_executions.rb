class CreateExecutions < ActiveRecord::Migration[6.1]
  def change
    create_table :executions do |t|
      t.bigint :account_id, null: false
      t.text :program, null: false
      t.text :input, null: false
      t.text :output, null: false
      t.integer :result, null: false
      t.timestamps
    end
  end
end
