class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :password_digest
      t.timestamps
    end

    add_index :accounts, :name, unique: true
  end
end
