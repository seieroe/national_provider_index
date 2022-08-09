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
    
    if api_response.status == 503
      flash[:notice] = 'Sorry, the API is down right now!'
      redirect_to index
      return
    end
    
    parsed_api_response = JSON.parse api_response.body
    
    if parsed_api_response['results'].nil?
      flash[:notice] = 'NOT A VALID NPI'
      redirect_to index
      return
    end
    
    details_from_api = parsed_api_response['results'][0]
    
    @npi = details_from_api['number']
    @name = details_from_api['basic']['name']
    @address = details_from_api['addresses'][0]['address_1'] + " " + details_from_api['addresses'][0]['address_2'] + " " + details_from_api['addresses'][0]['city'] + " " + details_from_api['addresses'][0]['state'] + " " + details_from_api['addresses'][0]['postal_code']
    @provider_type = details_from_api['enumeration_type']
    @taxonomy = details_from_api['taxonomies'][0]['desc']
    existing_record = ProviderDetail.find_by(npi: params['provider_detail']['npi'])
    if existing_record.present?
      existing_record.update(name: @name, 'npi': @npi, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
      existing_record.touch
    else
      @provider_detail = ProviderDetail.create(name: @name, npi: @npi, taxonomy: @taxonomy, provider_type: @provider_type, address: @address)
    end
    redirect_to index
    # raise api_response.status.inspect
    
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
