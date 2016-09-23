class ApiKeysController < ApplicationController
  before_action :set_api_key, only: [:show, :edit, :update, :destroy]

  # GET /api_keys
  # GET /api_keys.json
  def index
    if !current_user.nil?
      @user = User.find(current_user.id)
      @api_key = ApiKey.find(@user.api_key_id) if @user.api_key_id
    else
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    end
  end

  def update
    @user = User.find(current_user.id)
    @api_key = ApiKey.find(@user.api_key_id)

    if @api_key.update_attributes(api_key_params)
      redirect_to :back, notice:  "Your Key has been successfully updated."
    else
      render action: "index"
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_key
      @api_key = ApiKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_key_params
      # params[:api_key].permit(:api_key)
      params.require(:api_key).permit(:API_Key)
    end
end
