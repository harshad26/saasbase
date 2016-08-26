json.array!(@users) do |user|
  json.extract! user, :id, :id, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :name, :stripe_customer_id, :company_name, :company_address_1, :company_address_2, :company_city, :company_zipcode, :company_country, :first_name, :last_name, :card_number
  json.url user_url(user, format: :json)
end
