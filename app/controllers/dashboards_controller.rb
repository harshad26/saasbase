class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @stores = Store.all
  end
end
