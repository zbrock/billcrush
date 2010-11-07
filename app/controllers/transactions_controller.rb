class TransactionsController < ApplicationController
  before_filter :load_group

  def create
    payer = @group.members.find(params[:transaction][:payer])
    # create inactive so we can create the associated debts
    @transaction = @group.transactions.build(:description => params[:transaction][:description],
                                             :amount_cents => params[:transaction][:amount_cents].to_i,
                                             :active => false)
    if @transaction.save
      params[:transaction][:members].each do |member|
        debtor = @group.members.find(member[:id])
        @transaction.debts.create!(:debtor => debtor, :creditor => payer, :amount_cents => member[:amount].to_i)
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
end
