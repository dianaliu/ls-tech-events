class Event < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :twitter_handle, uniqueness: true
end
