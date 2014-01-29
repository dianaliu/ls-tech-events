class Event < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :twitter_handle, uniqueness: true

  def is_past?
    start_date.present? && start_date < Date.today
  end

  def is_upcoming?
    start_date.present? && start_date <= Date.today + 3.months
  end
end
