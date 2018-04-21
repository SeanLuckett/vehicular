class MakeSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :models
end
