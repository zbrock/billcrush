class AddDebtsToTransactions < ActiveRecord::Migration
  def self.up
    add_column :debts, :transaction_id, :integer
  end

  def self.down
    remove_column :debts, :transaction_id
  end
end
