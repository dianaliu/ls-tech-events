class Event < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :twitter_handle, uniqueness: true

  def as_json
    {
      :id => id,
      :name => name,
      :description => description,
      :event_type => event_type,
      :location => location,
      :start_date => start_date,
      :end_date => end_date,
      :twitter_handle => twitter_handle,
      :website_url => website_url,
      :logo => logo
    }
  end

  def is_past?
    start_date.present? && start_date < Date.today
  end

  def is_upcoming?
    range = Date.today..Date.today + 3.months
    start_date.present? && range.cover?(start_date)
  end
end
