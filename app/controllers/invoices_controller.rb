class InvoicesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !current_user.nil?
      @user = User.find_by_email(current_user.email)
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end

    @account = Account.find(@user.account_id)

    @subscription = Subscription.find_by_account_id(@account.id)

    customer = Stripe::Customer.retrieve(@subscription.stripe_customer_id)

    @invoices = customer.invoices
#    upcoming_invoices = customer.upcoming_invoices
  end

  def show
    if !current_user.nil?
      @user = User.find_by_email(current_user.email)
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end

    @account = Account.find(@user.account_id)

    @invoice = Stripe::Invoice.retrieve(params[:id])
  end
end
