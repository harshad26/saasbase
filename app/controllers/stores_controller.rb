class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:mapdata, :find_key]
  # GET /stores
  # GET /stores.json
  def index
    if params[:search]
      @stores = Store.where("account_id = ?",current_user.account_id).search(params[:search]).paginate(:page => params[:page])
    elsif params[:problems] == 'true'
      @stores = Store.where("lat = ? or long = ?", 'geo-coding', 'geo-coding' ).paginate(:page => params[:page])
    else
      @stores = Store.all.where("account_id = ?",current_user.account_id).paginate(:page => params[:page]) if current_user
      # @stores = Store.paginate(:page => params[:page])
    end
    test = Store.all.where("lat = ? or long = ?","geo-coding","geo-coding")
    if test.count > 0
      @c = test.count
      @display = true
    else
      @display = false
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
    Store.where(id: params[:stores]).delete_all
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all
    Store.where(account_id: current_user.account_id).delete_all
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_upload
    
  end

  def import
    file = params[:file].path

    batch,batch_size = [], 1_000 
    CSV.foreach(file, {:headers => true, :encoding => 'ISO-8859-1'}) do |row|
      row << { 'account_id' => current_user.account_id }

      hash = row.to_hash
      hash['name'] = hash.delete('Name')
      hash['address'] = hash.delete('Address')
      hash['phone'] = hash.delete('PhoneNumber')
      
      if hash['lat'] == nil
        hash['lat'] = 'geo-coding'
      end
      if hash['long'] == nil
        hash['long'] = 'geo-coding'
      end

      batch << Store.new(hash)

      if batch.size >= batch_size
        Store.import batch
        batch = []
      end

    end
    Store.import batch

    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully imported.' }
      format.json { head :no_content }
    end
  end

  def mapdata
    @stores = Store.all.where("account_id = ?",params[:id]);
    output = 'feed_callback('+{stores: @stores}.to_json+');'
    respond_to do |format|
      format.js { render :json => output }
    end
  end

  def find_key
    user = User.find(params[:id]);
    @setting = Setting.find_by_account_id(user.account_id)
    
    key = @setting.google_api_key
    if key == nil
      key = '000'
    end
    output = 'key_callback({"keys":[{"key":"'+key+'"}]});'
    respond_to do |format|
      format.js { render :json => output }
    end
  end

  def geocode
    res = []
    stores = Store.all.where("lat = ? or long = ?","geo-coding","geo-coding")
    redirect_to stores_url, notice: 'Your imported stores are being geocoded in the background. We will send you an email notification when it is complete. Email Support with any questions.'
    Thread.new do
      (0..stores.length).each do |i|
        res[i] =  Geokit::Geocoders::MultiGeocoder.geocode(stores[i].address)
        stores[i].lat = res[i].latitude.round(5)
        stores[i].long = res[i].longitude.round(5)
        stores[i].update params[:store]
        console.log(stores[i].inspect)
      end
      console.log('geocoding done')
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
