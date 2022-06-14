class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :role, :image, :image_url, :created_at, :updated_at
end
