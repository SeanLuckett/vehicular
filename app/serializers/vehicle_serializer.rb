class VehicleSerializer < ActiveModel::Serializer
  attributes :id, :owner

  belongs_to :model
  has_many :options
end
