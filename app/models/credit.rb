class Credit < ActiveRecord::Base
  validates :amount_cents, :member, :presence => true

  belongs_to :member, :inverse_of => :credits
  belongs_to :transaction
  scope :active, where(:active => true)
end
