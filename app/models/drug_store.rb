class DrugStore < ApplicationRecord
  belongs_to :user
  has_many_attached :pictures

  def get_location
    {
        lat: latitude,
        lng: longitude
    }
  end

  def sanitazed_info
    {
        id: id,
        name: name,
        description: description,
        owner: ::User.find(user_id),
        latitude: latitude,
        longitude: {
            lat: latitude,
            lng: longitude,
        },
        products: ::Inventory.where(:drug_store_id => id).map(&:sanitazed_info),
        images: pictures.map do |picture|
          rails_blob_path(picture, disposition: "attachment", only_path: true)
        end
    }
    end
end
