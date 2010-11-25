class Debit < ActiveRecord::Base
  validates :amount_cents, :member, :presence => true

  belongs_to :member, :inverse_of => :debits
  belongs_to :transaction
  scope :active, where(:active => true)
  
  def as_json(options={})
    [self.member.id, self.amount_cents]
  end
end
