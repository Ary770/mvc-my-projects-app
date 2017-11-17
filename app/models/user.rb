class User < ActiveRecord::Base
  has_secure_password
  has_many :projects
  has_many :categories, through: :projects
  # validates_presence_of :username, :password
end
