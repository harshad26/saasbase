class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    if params[:search]
      @stores = Store.where("account_id = ?",current_user.account_id).search(params[:search])
    else
      @stores = Store.all.where("account_id = ?",current_user.account_id) if current_user
    end
    respond_to do |format|
      format.html
       format.csv { send_data @stores.to_csv }
      # format.csv do
      #   headers['Content-Disposition'] = "attachment; filename=\"store-list\""
      #   headers['Content-Type'] ||= 'text/csv'
      # end
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)
    @store.account_id = current_user.account_id

    respond_to do |format|
      if @store.save
        format.html { redirect_to stores_url, notice: 'Store was successfully created.' }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to stores_url, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    Store.where(id: params[:stores]).destroy_all
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Store.destroy_all
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end    
  end

  def bulk_upload
    
  end

  def import
    file = params[:file].path

    CSV.foreach(file, :headers => true ) do |row|
      # abort row['id'].inspect

      store = Store.where(account_id: row["account_id"]).first || new
      # Store.create!(row.to_hash)
      store.attributes = row.to_hash.slice(*row.to_hash.keys)
      store.save!
    end    

    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully imported.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:name, :address, :phone, :email, :url, :description, :categories, :custom_field_1, :custom_field_2, :custom_field_3, :image_url, :custom_marker_url, :lat, :long )
    end
end
