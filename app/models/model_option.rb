class ModelOption < ApplicationRecord
  belongs_to :model
  belongs_to :option

  validates :option_id, uniqueness: { scope: :model_id }
end
