class Event < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :twitter_handle, presence: true, uniqueness: true
  validates :name, uniqueness: true
  validate :ends_after_starts

  def ends_after_starts
    if start_date && end_date && end_date < start_date
      errors.add(:end_date, "must end after start date")
    end
  end

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

  def set_dates(start_date, end_date=nil)
    update_attributes(:start_date => start_date, :end_date => end_date)
  end

  def formatted_start_and_end_date(format=:long)
    if start_date && end_date
      start_date.to_formatted_s(format) + " - " + end_date.to_formatted_s(format)
    elsif start_date
      start_date.to_formatted_s(format)
    end
  end
end
