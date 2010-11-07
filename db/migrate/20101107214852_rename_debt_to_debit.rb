class RenameDebtToDebit < ActiveRecord::Migration
  def self.up
    rename_table :debts, :debits
  end

  def self.down
    rename_table :debits, :debts    
  end
end
