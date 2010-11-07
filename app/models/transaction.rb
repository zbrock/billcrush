class Transaction < ActiveRecord::Base
  has_many :debits
  belongs_to :group
  validates :group, :presence => true
  validates_numericality_of :amount, :greater_than => 0

  def validate_and_activate!
    ActiveRecord::Base.transaction do
      return false if debits.sum(:amount_cents) != amount
      update_attributes(:active => true)
      debits.update_all({:active => true})
    end
  end
end
