class Rating < ApplicationRecord
  validates :value, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  scope :average_rating, -> { average(:value)&.round }
end
