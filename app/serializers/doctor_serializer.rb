class DoctorSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :city, :specialization, :cost_per_day, :description, :image, :image_url, :created_at, :updated_at
end
