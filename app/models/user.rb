class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
end
