class DropCreditorColumnFromDebits < ActiveRecord::Migration
  def self.up
    remove_column :debits, :creditor_id
    remove_column :debits, :debtor_id
    add_column :debits, :member_id, :integer
  end

  def self.down
    raise IrreversibleMigration
  end
end
