class Debt < ActiveRecord::Base
  validates :amount_cents, :debtor, :creditor, :presence => true

  belongs_to :debtor, :class_name => "Member", :inverse_of => :debits
  belongs_to :creditor, :class_name => "Member", :inverse_of => :credits
  belongs_to :transaction
  scope :active, where(:active => true)
end
