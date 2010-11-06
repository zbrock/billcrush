require 'factory_girl'
require 'forgery'

Factory.define(:group) do |g|
  g.name {Forgery(:name).company_name}
end