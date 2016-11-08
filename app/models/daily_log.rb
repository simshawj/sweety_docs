class DailyLog < ApplicationRecord
  validates :log_date, presence: true
  validates :log_date, :uniqueness => {:scope => :user_id}
  validates :values, presence: true
  validate  :values_is_array
  validate  :max_four_values
  validate  :all_values_are_integers

  belongs_to :user

  serialize :values

  def add(value)
    values << value
  end

  def values_is_array
    unless values.is_a?(Array)
      errors[:values] << "Values must be able to take multiple values"
    end
  end

  def max_four_values
    unless values.is_a?(Array) && values.length < 5
      errors[:values] << "Cannot have more than 4 values per day"
    end
  end

  def all_values_are_integers
    if values.is_a?(Array)
      values.each do |value|
        unless value.is_a?(Integer)
          errors[:values] << "#{value} is not an integer"
        end
      end
    end
  end
end
