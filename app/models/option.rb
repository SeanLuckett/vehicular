class Option < ApplicationRecord
  has_many :model_options, dependent: :destroy
  has_many :models, through: :model_options

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
