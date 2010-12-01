class TransactionsController < ApplicationController
  before_filter :load_group

  def create
    payer = @group.members.find(params[:transaction][:payer])
    cookies[@group.id.to_s + '_last_payer'] = payer.id
    # create inactive so we can create the associated debts
    amount = amount_cents(params[:transaction][:amount])
    @transaction = @group.transactions.build(:description => params[:transaction][:description],
                                             :date => params[:transaction][:date],
                                             :amount => amount,
                                             :active => false, :settlement => params[:transaction][:settlement])
    if @transaction.save
      @transaction.credits.create!(:member => payer, :amount_cents => amount, :active => false)
      params[:transaction][:members].each_pair do |id, amount|
        debtor = @group.members.find(id)
        debt_amount = amount_cents(amount)
        @transaction.debits.create!(:member => debtor, :amount_cents => debt_amount)
      end
    end

    # check that all associated data is in good order before making active
    if @transaction.validate_and_activate!
      flash[:message] = "Transaction added!"
    else
      flash[:error] = "Error!"
    end
    redirect_to group_url(@group)
  end

  def destroy
    transaction = @group.transactions.find_by_id(params[:id])
    if transaction
      transaction.mark_as_deleted!
      flash[:message] = "Transaction deleted!"
    else
      flash[:error] = "Error deleting transaction!"
    end
    redirect_to group_url(@group)
  end
end