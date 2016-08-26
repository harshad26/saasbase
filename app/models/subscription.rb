class Subscription < ActiveRecord::Base
  belongs_to :user

  def save_payment_details
    if valid?
      save_with_stripe_payment
    end
  end

  def save_payment_details_stripe(stripe_token, email, stripe_plan_id)
    customer = Stripe::Customer.create(source: stripe_token, plan: stripe_plan_id, email: email)
    self.stripe_token = customer.cards.data.first["id"]
    self.stripe_customer_id = customer.id
    self.stripe_subscription_id = customer.subscriptions.data.first["id"]
    self.last_4_digits = customer.cards.data.first["last4"]
    save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def update_card(stripe_customer_token, stripe_card_token)
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    card = customer.sources.create(card: stripe_card_token)
    card.save
    customer.default_source = card.id
    customer.save
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message}"
    errors.add :base, "#{e.message}"
    false
  end

end
