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
    api_response = Faraday.get "https://npiregistry.cms.hhs.gov/api/?version=2.0&number=#{params['provider_detail']['npi']}"
    
    parsed_api_response = JSON.parse api_response.body
    if parsed_api_response['results'].nil?
      # redirect_to index, flash: { error: "Not a valid NPI" }
      flash[:notice] = 'Not a valid NPI'
      redirect_to index
      return
    else
      @npi = parsed_api_response['results'][0]['number']
      @name = parsed_api_response['results'][0]['basic']['name']
      @address = parsed_api_response['results'][0]['addresses'][0]['address_1'] + " " + parsed_api_response['results'][0]['addresses'][0]['address_2'] + " " + parsed_api_response['results'][0]['addresses'][0]['city'] + " " + parsed_api_response['results'][0]['addresses'][0]['state'] + " " + parsed_api_response['results'][0]['addresses'][0]['postal_code']
      @provider_type = parsed_api_response['results'][0]['enumeration_type']
      @taxonomy = parsed_api_response['results'][0]['taxonomies'][0]['desc']
    end
    if ProviderDetail.where(npi: params['provider_detail']['npi']).present?
      existing_record = ProviderDetail.where(npi: params['provider_detail']['npi'])
      @provider_detail = existing_record.update(existing_record[0]['id'], name: @name, 'npi': @npi, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
      @provider_detail.touch
    else
      @provider_detail = ProviderDetail.create(name: @name, npi: @npi, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
    end
    redirect_to '/index'
    # raise parsed_api_response['results'].inspect
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_detail
      @provider_detail = ProviderDetail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def provider_detail_params
      params.require(:provider_detail).permit(:npi, :name, :address, :provider_type, :taxonomy)
    end
end
