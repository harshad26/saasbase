class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
	redirect_to stores_path
  end

  def show
	redirect_to stores_path
  end
end
