class RegistrationsController < Devise::RegistrationsController

  def create
    build_resource(sign_up_params)

    if !params[:plan_id].present?
      flash[:notice] = "Missing Plan ID."
      render :new
      return
    end

    resource.save

    yield resource if block_given?

    if resource.persisted?

      @account = Account.create
      resource.account_id = @account.id
      resource.save

      @plan = Plan.find(params[:plan_id])
      @subscription = Subscription.new
      @subscription.account_id = @account.id
      @subscription.stripe_plan_id = @plan.stripe_plan_id
      @subscription.save_payment_details_stripe(params[:stripe_token], params[:email], @plan.stripe_plan_id)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      respond_with resource
    end

  end

  def after_sign_up_path_for(resource)
    dashboards_path
  end

end