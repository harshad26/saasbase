class CreateStripeSubscription
  def self.call(plan, email_address, token)

    Rails.logger.info self.class.name + ': email = ' + email_address + ', plan.stripe_id = ' + plan.stripe_id
    stripe_sub = nil
    customer = nil

    begin
      #user = User.find_by(email: email_address)

      stripe_customers = Stripe::Customer.all

      stripe_customers.each do |row|
        if row.email == email_address
          customer = Stripe::Customer.retrieve(row.id)
        end
      end

      if customer.nil?
        Rails.logger.info self.class.name + ': New Stripe Customer'
        customer = Stripe::Customer.create(
            source: token,
            email: email_address,
            plan: plan.stripe_id,
        )
        stripe_sub = customer.subscriptions.first
        Rails.logger.info self.class.name + ': Stripe User ID = ' + customer.id.to_s + ', Stripe Subscr ID = ' + customer.subscriptions.first.id.to_s
      else
        Rails.logger.info self.class.name + ': Stripe Customer exists'
        stripe_sub = customer.subscriptions.create(
            plan: plan.stripe_id
        )
        Rails.logger.info self.class.name + ': Stripe User ID = ' + customer.id.to_s + ', Stripe Subscr ID = ' + customer.subscriptions.first.id.to_s
      end

    rescue Stripe::StripeError => e
      Rails.logger.error self.class.name + ': failed: ' + e.message

      if !stripe_sub.nil?
        stripe_sub.errors[:base] << e.message
      end
    end

    stripe_sub
  end
end