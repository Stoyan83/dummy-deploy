class Rating < ApplicationRecord
  validates :value, presence: true, inclusion: { in: 1..5 }

  scope :average_rating, -> { average(:value)&.round }

  after_commit :prune_excess_records

  MAX_RECORDS = 50

  private

  def prune_excess_records
    self.class.first.destroy if self.class.count > MAX_RECORDS
  end
end
