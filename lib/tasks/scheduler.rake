desc "update events from twitter @dianagliu/conferences list"
task :update_from_twitter => :environment do |t|
  if Time.now.friday?
    client = Twitter::REST::Client.new({
      :consumer_key => ENV['TWITTER_CONSUMER_KEY'],
      :consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
      :access_token => ENV['TWITTER_ACCESS_TOKEN'],
      :access_token_secret => ENV['TWITTER_ACCESS_TOKEN_SECRET']
      })

    members = JSON.parse(client.list_members(103196694).to_json)
    members.each do |m|
      e = Event.find_or_initialize_by_name({
          :name => m['name'],
          :description => m['description'],
          :location => m['location'],
          :twitter_handle => m['screen_name'],
          :website_url => m['entities']['url']['urls'][0]['expanded_url'],
          :logo => m['profile_image_url']
        })
      e.save! if e.new_record?
    end
  end
end