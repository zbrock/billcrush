class AddAmountCentsToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :amount_cents, :integer
  end

  def self.down
    remove_column :transactions, :amount_cents
  end
end
