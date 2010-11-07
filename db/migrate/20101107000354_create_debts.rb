class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.belongs_to(:debtor)
      t.belongs_to(:creditor)
      t.integer(:amount_cents)
      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
