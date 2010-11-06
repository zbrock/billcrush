class Group < ActiveRecord::Base
  include ActiveSupport::Inflector
  validates :name, :presence => true
  before_save :canonicalize_name

  private
  def canonicalize_name
    self.canonicalized_name = parameterize(name)
  end
end
