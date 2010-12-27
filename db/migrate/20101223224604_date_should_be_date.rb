class DateShouldBeDate < ActiveRecord::Migration
  def self.up
    add_column :transactions, :temp_date, :datetime
    Transaction.reset_column_information
    Transaction.all.each do |transaction|
      if transaction.date.present? &&  transaction.date.class.is_a?(String)
        transaction.temp_date = Date.parse(transaction.date)
      else
        transaction.temp_date = transaction.date
      end
      transaction.save!
    end
    remove_column :transactions, :date
    rename_column :transactions, :temp_date, :date
  end

  def self.down
  end
end
