class ChangeAmountCentsOnTransactionToAmount < ActiveRecord::Migration
  def self.up
    rename_column :transactions, :amount_cents, :amount
  end

  def self.down
    rename_column :transactions, :amount, :amount_centse
  end
end
