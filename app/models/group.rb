class Group < ActiveRecord::Base
  validates :name, :presence => true
  before_save :canonicalize_name
  has_many :members

  private
  def canonicalize_name
    self.canonicalized_name = name.parameterize
  end
end
