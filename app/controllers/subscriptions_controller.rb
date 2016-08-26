class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !current_user.nil?
      @user = User.find_by_email(current_user.email)
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end

    @subscription = Subscription.find_by_account_id(@user.account_id)
    @plans = Plan.all
  end

  def update
    @user = User.find_by_email(current_user.email)
    @subscription = Subscription.find_by_account_id(@user.account_id)
    customer = Stripe::Customer.retrieve(@subscription.stripe_customer_id)
    subscription = customer.subscriptions.retrieve(@subscription.stripe_subscription_id)
#    @plan = Plan.find_by_stripe_plan_id(params[:current_plan])
#    subscription.plan = @plan.stripe_plan_id

    subscription.plan = params[:current_plan]
    subscription.save

    @subscription.stripe_plan_id = params[:current_plan]
    @subscription.save

    redirect_to :back
  end

  def cancel
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end

  def edit_card
    @subscription = Subscription.find_by_user_id(current_user.id)
  end

  def update_card
    @subscription = Subscription.find_by_user_id(current_user.id)

    if @subscription.update_card(@subscription, params[:stripe_card_token])
      flash[:success] = 'Saved. Your card information has been updated.'
      redirect_to @subscription
    else
      flash[:warning] = 'Stripe reported an error while updating your card. Please try again.'
      redirect_to @subscription
    end
  end
end
