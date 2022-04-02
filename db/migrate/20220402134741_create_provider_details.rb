class CreateProviderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :provider_details do |t|
      t.string :npi
      t.string :name
      t.string :address
      t.string :provider_type
      t.string :taxonomy

      t.timestamps
    end
  end
end
