class Circle < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 255 }
end
