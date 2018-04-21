class Model < ApplicationRecord
  belongs_to :make

  validates :name, uniqueness: { scope: :year }, presence: true

  validates :year,
            numericality: { only_integer: true },
            length: { is: 4 },
            presence: true
end
