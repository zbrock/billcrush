class Member < ActiveRecord::Base
  validates :name, :group,  :presence => true
  belongs_to :group

  has_many :debits
  has_many :credits

  def balance
    (credits.active.sum(:amount_cents) - debits.active.sum(:amount_cents)).to_i
  end

  def debits_for_transaction(transaction)
    transaction.debits.scoped_by_member_id(self).sum(:amount_cents)
  end
end
