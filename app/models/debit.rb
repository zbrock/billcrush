class Debit < ActiveRecord::Base
  validates :amount_cents, :member, :presence => true

  belongs_to :member, :inverse_of => :debits
  belongs_to :transaction
  scope :active, where(:active => true)
end