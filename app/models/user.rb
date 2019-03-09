class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # ,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :trackable,
         :lockable, :timeoutable, :confirmable

  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist
end
