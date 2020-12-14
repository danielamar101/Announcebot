class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username
  validates_uniqueness_of :username

  #TODO: Create relation
  # has_one :key
end
