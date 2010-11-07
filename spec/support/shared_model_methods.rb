def create_debit_credit_pair(debit_member, credit_member, amount)
  Factory(:debit, :member => debit_member, :amount_cents => amount)
  Factory(:credit, :member => credit_member, :amount_cents => amount)  
end