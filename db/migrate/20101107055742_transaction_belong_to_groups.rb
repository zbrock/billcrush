class TransactionBelongToGroups < ActiveRecord::Migration
  def self.up
    add_column :transactions, :group_id, :integer
  end

  def self.down
    remove_column :transactions, :group_id
  end
end
