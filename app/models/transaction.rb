class Transaction < ActiveRecord::Base
  has_many :debts
  belongs_to :group
  validates :group, :presence => true
end
