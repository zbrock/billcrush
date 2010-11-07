class TransactionsController < ApplicationController
  before_filter :load_group

  def create
    if Transaction.add(params[:transaction])
      params[:message] = "Transaction added!"
    else
      params[:error] = "Error!"
    end
    redirect_to group_url(@group)
  end
end
