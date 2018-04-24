class Vehicle < ApplicationRecord
  belongs_to :model

  has_many :vehicle_options, dependent: :destroy
  has_many :options, through: :vehicle_options
end
