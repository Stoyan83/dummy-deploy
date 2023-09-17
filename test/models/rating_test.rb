# frozen_string_literal: true

require "test_helper"

class RatingTest < ActiveSupport::TestCase
  def setup
    @rating = Rating.new(value: 5)
  end

  test 'should have value' do
    assert @rating.valid?
  end

  test 'value should be within the range of 1 to 5' do
    [-1, 0, 6, 7].each do |value|
      @rating.value = value
      assert_not @rating.valid?
    end

    [1, 2, 3, 4, 5].each do |value|
      @rating.value = value
      assert @rating.valid?
    end
  end

  test 'average_rating should return the correct average' do
    [1, 2, 3].each do |value|
      Rating.create(value:)
    end

    assert_equal 2, Rating.average_rating
  end

  test 'prune_excess_records should remove the oldest records when count exceeds MAX_RECORDS' do
    (Rating::MAX_RECORDS + 1).times do
      Rating.create(value: 1)
    end

    assert_operator Rating.count, :<=, Rating::MAX_RECORDS
  end
end
