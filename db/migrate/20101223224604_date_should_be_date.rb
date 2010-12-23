class DateShouldBeDate < ActiveRecord::Migration
  def self.up
    add_column :transactions, :temp_date, :datetime
    Transaction.reset_column_information
    Transaction.all.each do |transaction|
      transaction.temp_date = Date.parse(transaction.date) if transaction.date.present?
      transaction.save!
    end
    remove_column :transactions, :date
    rename_column :transactions, :temp_date, :date
  end

  def self.down
  end
end
