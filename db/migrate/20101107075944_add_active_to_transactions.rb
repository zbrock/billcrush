class AddActiveToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :active, :boolean, :default => false
  end

  def self.down
    remove_column :transactions, :active
  end
end
