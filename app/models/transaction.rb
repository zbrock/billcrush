class Transaction < ActiveRecord::Base
  has_many :debits
  has_many :credits
  belongs_to :group
  validates :group, :presence => true
  validates_numericality_of :amount, :greater_than => 0

  def validate_and_activate!
    ActiveRecord::Base.transaction do
      return false if debits.sum(:amount_cents) != credits.sum(:amount_cents)
      return false if debits.sum(:amount_cents) != amount
      update_attributes(:active => true)
      debits.update_all({:active => true})
      credits.update_all({:active => true})
    end
  end

  def mark_as_deleted!
    ActiveRecord::Base.transaction do
      update_attributes(:active => false, :deleted_at => Time.now.utc)
      debits.update_all({:active => false})
      credits.update_all({:active => false})
    end
  end
  
  def display_date
    self.date.try(:to_date) || self.created_at.to_date
  end
  
  def as_json(options={})
    { :description => self.description,
      :amount => self.amount,
      :debits => self.debits.find_all{|m| m.amount_cents > 0},
      :credits => self.credits.find_all{|m| m.amount_cents > 0} }
  end
end
