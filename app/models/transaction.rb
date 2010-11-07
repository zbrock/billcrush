class Transaction < ActiveRecord::Base
  has_many :debts
  
end
