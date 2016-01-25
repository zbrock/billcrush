class Api::TransactionsController < Api::ApiController
  def create
    @group = Group.find_by_canonicalized_name!(params[:group_id])

    payload = JSON.parse(request.body.read)
    params.merge!(payload.with_indifferent_access)

    payer = @group.members.find(params[:transaction][:payer])
    amount = amount_cents(params[:transaction][:amount])
    date = Date.parse(params[:transaction][:date], "%m/%d/%Y") if params[:transaction][:date].present?
    @transaction = @group.transactions.build(:description => params[:transaction][:description],
                                             :date => date,
                                             :amount => amount,
                                             :active => false,
                                             :settlement => params[:transaction][:settlement])

    if @transaction.save
      @transaction.credits.create!(:member => payer, :amount_cents => amount, :active => false)
      params[:transaction][:members].each do |member|
        debtor = @group.members.find(member[:id])
        debt_amount = amount_cents(member[:amount])
        @transaction.debits.create!(:member => debtor, :amount_cents => debt_amount)
      end
    else
      message = "error saving"
    end

    if @transaction.validate_and_activate!
      message = "ok"
    else
      message = "error validating and activating"
    end

    render json: {status: message}.to_json
  end
end
