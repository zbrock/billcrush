class CreateCredits < ActiveRecord::Migration
  def self.up
    create_table :credits do |t|
      t.belongs_to(:member)
      t.integer(:amount_cents)
      t.belongs_to(:transaction)
      t.boolean :active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :credits
  end
end
