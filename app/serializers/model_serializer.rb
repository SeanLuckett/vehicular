class ModelSerializer < ActiveModel::Serializer
  attributes :id, :name, :year

  belongs_to :make
end
