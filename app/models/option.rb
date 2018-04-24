class Option < ApplicationRecord
  has_many :model_options, dependent: :destroy
  has_many :models, through: :model_options

  has_many :vehicle_options, dependent: :destroy
  has_many :vehicles, through: :vehicle_options

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
