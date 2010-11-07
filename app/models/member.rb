class Member < ActiveRecord::Base
  validates :name, :group,  :presence => true
  belongs_to :group

  has_many :debits, :class_name => "Debit", :foreign_key => "debtor_id"
  has_many :credits, :class_name => "Debit", :foreign_key => "creditor_id"

  def balance
    credits.active.sum(:amount_cents) - debits.active.sum(:amount_cents)
  end
end
