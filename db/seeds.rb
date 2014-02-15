# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

json = JSON.parse(open('http://ls-tech-events.herokuapp.com/events/export').read)
json.each do |event|
  Event.create!({
      :id => event['id'],
      :name => event['name'],
      :description => event['description'],
      :event_type => event['event_type'],
      :location => event['location'],
      :start_date => event['start_date'],
      :end_date => event['end_date'],
      :twitter_handle => event['twitter_handle'],
      :website_url => event['website_url'],
      :logo => event['logo']
    })
end