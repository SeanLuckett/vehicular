class Make < ApplicationRecord
  has_many :models, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
