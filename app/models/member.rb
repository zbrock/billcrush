class Member < ActiveRecord::Base
  validates :name, :group,  :presence => true
  belongs_to :group
end
