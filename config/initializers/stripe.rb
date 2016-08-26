require 'stripe'

Rails.configuration.stripe = {
    :secret_key      => ENV['STRIPE_SECRET_KEY'] || Rails.application.secrets.STRIPE_SECRET_KEY,
    :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'] || Rails.application.secrets.STRIPE_PUBLISHABLE_KEY
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]