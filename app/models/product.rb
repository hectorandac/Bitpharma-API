class Product < ApplicationRecord
  has_and_belongs_to_many :users
  has_many_attached :pictures
  searchkick word_middle: [:product_name],
             callbacks: :async

  def search_data
    {
      id: id,
      name: name,
      description: description,
      barcode: barcode,
      price: price,
      product_name: "#{description} #{name} #{barcode} #{price} #{id}"
    }
  end

  def sanitized_info
    {
      id: id,
      name: name,
      description: description,
      barcode: barcode,
      price: price,
      images: pictures.map do |picture|
        rails_blob_path(picture, disposition: "attachment", only_path: true)
      end
    }
  end

end
