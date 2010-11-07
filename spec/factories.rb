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
  d.association(:transaction)
  d.active true
  d.amount_cents { Forgery(:basic).number({:at_least => 1_00, :at_most => 10_00}) }
end

Factory.define(:transaction) do |t|
  t.association(:group)
  t.amount { Forgery(:basic).number({:at_least => 1_00, :at_most => 10_00}) }
  t.description { Forgery(:lorem_ipsum).words(2) }
end