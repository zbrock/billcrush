class AddActiveToDebts < ActiveRecord::Migration
  def self.up
    add_column :debts, :active, :boolean, :default => false
  end

  def self.down
    remove_column :debts, :active
  end
end
