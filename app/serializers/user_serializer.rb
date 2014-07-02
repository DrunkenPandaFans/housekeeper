class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :image, :send_sms
end
