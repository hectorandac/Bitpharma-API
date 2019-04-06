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
      first_name: first_name,
      last_name: last_name,
      profile_picture_url: nil,
      roles: roles.map(&:name)
    }
  end
end
