class DrugStore < ApplicationRecord
  belongs_to :user
  has_many_attached :pictures

  def get_location
    {
        lat: latitude,
        lng: longitude
    }
  end
end
