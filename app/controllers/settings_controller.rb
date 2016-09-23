class SettingsController < ApplicationController
  before_action :set_api_key, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  def index
    if !current_user.nil?
      @user = User.find(current_user.account_id)
      @api_key = Setting.find_by_account_id(@user)
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def update
    @user = User.find(current_user.account_id)
    @api_key = Setting.find_by_account_id(@user)

    if @api_key.update_attributes(api_key_params)
      redirect_to :back, notice:  "Your Key has been successfully updated."
    else
      render action: "index"
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      params.require(:setting).permit(:google_api_key)
    end
end
