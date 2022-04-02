class ProviderDetailsController < ApplicationController
  before_action :set_provider_detail, only: %i[ show edit update destroy ]

  # GET /provider_details or /provider_details.json
  def index
    @provider_details = ProviderDetail.all
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
    api_response = Faraday.get 'https://npiregistry.cms.hhs.gov/api/?version=2.0&number=1255985933' 
    
    parsed_api_response = JSON.parse api_response.body
    @name = parsed_api_response['results'][0]['basic']['name']
    
    # if ProviderDetail.exists?
    #   @provider_detail = ProviderDetail.update(provider_detail_params)
    # else
      @provider_detail = ProviderDetail.create(name: @name)
    # end

    # raise @provider_detail.inspect

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
