class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.belongs_to :group
      t.string :name
      t.boolean :active, :default => true, :allow_nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
