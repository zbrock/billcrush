class Transaction < ActiveRecord::Base
  has_many :debts
  belongs_to :group
  validates :group, :presence => true
  validates_numericality_of :amount, :greater_than => 0

  def validate_and_activate!
    ActiveRecord::Base.transaction do
      return false if debts.sum(:amount_cents) != amount
      update_attributes(:active => true)
      debts.update_all({:active => true})
    end
  end
end
