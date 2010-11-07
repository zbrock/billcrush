class Member < ActiveRecord::Base
  validates :name, :group,  :presence => true
  belongs_to :group

  has_many :debits
  has_many :credits

  def balance
    credits.active.sum(:amount_cents) - debits.active.sum(:amount_cents)
  end
end
