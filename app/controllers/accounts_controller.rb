class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if !current_user.nil?
      @user = User.find(current_user.id)
      @account = Account.find(@user.account_id)
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def update
    @user = User.find(current_user.id)
    @account = Account.find(@user.account_id)

    if @account.update_attributes(account_parameters)
      redirect_to :back, notice:  "Your account has been successfully updated."
    else
      render action: "index"
    end
  end

  private
  def account_parameters
    params[:account].permit(:company_name, :company_address_1, :company_address_2,
                  :company_city, :company_country, :company_zipcode,
                  :first_name, :last_name)
  end
end
