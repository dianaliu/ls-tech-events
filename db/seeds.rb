# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

json = ActiveSupport::JSON.decode(File.read('public/events.json'))
json['users'].each do |user|
  Event.create!({
      :name => user['name'],
      :description => user['description'],
      :location => user['location'],
      :twitter_handle => user['screen_name'],
      :website_url => user['entities']['url']['urls'][0]['expanded_url'],
      :logo => user['profile_image_url']
    })
end