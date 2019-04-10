# frozen_string_literal: true\
include Rails.application.routes.url_helpers

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # ,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :trackable,
         :lockable, :timeoutable, :confirmable

  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  after_create :assign_default_role
  has_many :drug_stores
  has_one_attached :profile_image
  has_and_belongs_to_many :products
  has_many :orders

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def assign_role(role)
    add_role(role)
  end

  def sanitized_info
    {
      id: id,
      email: email,
      complete_name: complete_name,
      phone_number: phone_number,
      address: address,
      profile_picture_url: profile_image.attached? ? rails_blob_path(profile_image, disposition: "attachment", only_path: true) : nil,
      roles: roles.map(&:name),
      stripe_id: stripe_id
    }
  end
end
