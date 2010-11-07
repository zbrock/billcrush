class Member < ActiveRecord::Base
  validates :name, :group,  :presence => true
  belongs_to :group

  has_many :debits, :class_name => "Debt", :foreign_key => "debtor_id"
  has_many :credits, :class_name => "Debt", :foreign_key => "creditor_id"

  def balance
    credits.sum(:amount_cents) - debits.sum(:amount_cents)
  end
end
