class AddDateToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :date, :date
  end

  def self.down
  end
end
