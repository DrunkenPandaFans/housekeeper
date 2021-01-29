class Circle < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 255 }

  scope :search, ->(name) do
    where("lower(name) like ?", "%#{name.downcase}%")
  end

end
