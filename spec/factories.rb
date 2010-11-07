require 'factory_girl'
require 'forgery'

Factory.define(:group) do |g|
  g.name { Forgery(:name).company_name }
end

Factory.define(:member) do |m|
  m.association(:group)
  m.name { Forgery(:name).first_name }
end

Factory.define(:debt) do |d|
  d.association(:debtor, :factory => :member)
  d.association(:creditor, :factory => :member)
  d.amount_cents { Forgery(:basic).number({:at_least => 1_00, :at_most => 10_00}) }
end