class Model < ApplicationRecord
  belongs_to :make
  has_many :vehicles

  has_many :model_options, dependent: :destroy
  has_many :options, through: :model_options

  validates :name,
            uniqueness: { scope: :year, case_sensitive: false },
            presence: true

  validates :year,
            numericality: { only_integer: true },
            length: { is: 4 },
            presence: true
end
