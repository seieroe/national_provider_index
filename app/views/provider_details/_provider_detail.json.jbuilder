json.extract! provider_detail, :id, :npi, :name, :address, :type, :taxonomy, :created_at, :updated_at
json.url provider_detail_url(provider_detail, format: :json)
