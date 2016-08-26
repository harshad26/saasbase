class CreateSubscription

  def self.call(plan, email_address, token)

    #Create Stripe Subscription
    stripe_sub = CreateStripeSubscription.call(
        plan,
        email_address,
        token
    )

    if !stripe_sub.nil?

      #Look for an user with this email. If not exists - create.
      user = User.find_by_email(email_address)

      if user.nil?
        Rails.logger.info self.class.name +  ': User is nil!'
        generated_password = Devise.friendly_token.first(8)
        user = User.new(:email => email_address, :password => generated_password,
                        :password_confirmation => generated_password, :stripe_customer_id => stripe_sub.customer)

        if !user.valid?
          Rails.logger.info self.class.name + ': User is invalid!'
        end

        user_saved = user.save

        if !user_saved
          Rails.logger.error self.class.name + ' User not saved!'
          user.errors.each do |attribute, message|
            Rails.logger.error self.class.name +  ': user.error = ' + message
          end
        else
          Rails.logger.info self.class.name + ' User saved'
        end
      else
        #TODO: This is a case of someone registering repeatedly (or a past user?). Need to think more on what to do.
        Rails.logger.info self.class.name + ': User existed!'
      end

      if !user.nil? && !user.errors.any?
        #Create a new Subscription
        Rails.logger.info self.class.name + ': user.email = ' + user.email
        subscription = Subscription.new(
            plan: plan,
            user: user
        )
        subscription.stripe_id = stripe_sub.id
        subscription.save!
        Rails.logger.info self.class.name + ': Subscription saved'
      else
        Rails.logger.info self.class.name + ': Conditions not met to save Subscription'
      end
    else
      Rails.logger.info self.class.name + ': Error'
    end
    generated_password
  end
end