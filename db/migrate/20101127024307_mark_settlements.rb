class MarkSettlements < ActiveRecord::Migration
  def self.up
    add_column :transactions, :settlement, :boolean, :default => false
  end

  def self.down
    remove_column :transactions, :settlement
  end
end
