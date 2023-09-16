class Rating < ApplicationRecord
  validates :value, presence: true, inclusion: { in: 1..5 }

  scope :average_rating, -> { average(:value)&.round }
end
