class ProviderDetailsController < ApplicationController
  before_action :set_provider_detail, only: %i[ show edit update destroy ]

  # GET /provider_details or /provider_details.json
  def index
    @provider_details = ProviderDetail.all.order(updated_at: :desc)
    @provider_detail = ProviderDetail.new

  end

  # GET /provider_details/1 or /provider_details/1.json
  def show
  end

  # GET /provider_details/new
  def new
    @provider_detail = ProviderDetail.new
  end

  # GET /provider_details/1/edit
  def edit
  end

  # POST /provider_details or /provider_details.json
  def create
    #TODO: interpolate number
    api_response = Faraday.get "https://npiregistry.cms.hhs.gov/api/?version=2.0&number=#{params['provider_detail']['npi']}"
    
    parsed_api_response = JSON.parse api_response.body
    @npi = parsed_api_response['results'][0]['number']
    @name = parsed_api_response['results'][0]['basic']['name']
    @address = parsed_api_response['results'][0]['addresses'][0]['address_1'] + " " + parsed_api_response['results'][0]['addresses'][0]['address_2'] + " " + parsed_api_response['results'][0]['addresses'][0]['city'] + " " + parsed_api_response['results'][0]['addresses'][0]['state'] + " " + parsed_api_response['results'][0]['addresses'][0]['postal_code']
    @provider_type = parsed_api_response['results'][0]['enumeration_type']
    @taxonomy = parsed_api_response['results'][0]['taxonomies'][0]['desc']
    #TODO: interpolate number
    if ProviderDetail.where(npi: params['provider_detail']['npi']).present?
      existing_record = ProviderDetail.where(npi: params['provider_detail']['npi'])
      @provider_detail = existing_record.update(existing_record[0]['id'], name: @name, 'npi': 1255985933, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
      @provider_detail.touch
    else
      @provider_detail = ProviderDetail.create(name: @name, npi: @npi, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
    end
    redirect_to '/index'
    # raise params['provider_detail']['npi'].inspect

    

    # respond_to do |format|
    #   if @provider_detail.save
    #     # format.html { redirect_to index, notice: "Provider detail was successfully created." }
    #     format.html { redirect_to provider_detail_url(@provider_detail), notice: "Provider detail was successfully created." }
    #     # format.json { render :show, status: :created, location: @provider_detail }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     # format.json { render json: @provider_detail.errors, status: :unprocessable_entity }
    #   end
    # end
    
  end

  # PATCH/PUT /provider_details/1 or /provider_details/1.json
  def update
    respond_to do |format|
      if @provider_detail.update(provider_detail_params)
        format.html { redirect_to provider_detail_url(@provider_detail), notice: "Provider detail was successfully updated." }
        format.json { render :show, status: :ok, location: @provider_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @provider_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provider_details/1 or /provider_details/1.json
  def destroy
    @provider_detail.destroy

    respond_to do |format|
      format.html { redirect_to provider_details_url, notice: "Provider detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_detail
      @provider_detail = ProviderDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def provider_detail_params
      params.require(:provider_detail).permit(:npi, :name, :address, :type, :taxonomy)
    end
end
