class OptionalGroupPassword < ActiveRecord::Migration
  def self.up
    add_column :groups, :password_hash, :string
  end

  def self.down
    remove_column :groups, :password_hash    
  end
end
