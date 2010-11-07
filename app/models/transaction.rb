class Transaction < ActiveRecord::Base
  has_many :debts
  belongs_to :group
  validates :group, :presence => true
  validates_numericality_of :amount_cents, :greater_than => 0

  def validate_and_activate!
    return false if debts.sum(:amount_cents) != amount_cents
    update_attributes(:active => true)
    debts.update_all({:active => true})
  end
end
