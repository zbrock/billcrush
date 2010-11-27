class DeletedAtToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :deleted_at, :datetime
  end

  def self.down
    remove_column :transactions, :deleted_at

  end
end
