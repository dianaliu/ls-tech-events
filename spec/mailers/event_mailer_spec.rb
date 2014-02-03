require "spec_helper"

describe EventMailer do
  describe ".weekly_digest" do
    it "sends an email" do
      changes = { :updated => [], :created => [] }
      EventMailer.weekly_digest(changes).deliver

      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it "sends the correct content" do
      stub_const('ENV', {'ADMIN_EMAIL' => 'diana.g.liu@gmail.com'})
      pot = Event.create(:twitter_handle => 'pot', :name => "black pot")
      kettle = Event.create(:twitter_handle => 'kettle', :name => "kettle")
      kettle.update_attribute(:name, 'black kettle')
      changes = { :updated => [kettle], :created => [pot] }

      email = EventMailer.weekly_digest(changes).deliver

      expect(email.from).to include('no-reply@ls-tech-events.herokuapp.com')
      expect(email.to).to include(ENV['ADMIN_EMAIL'])
      expect(email.subject).to eq('New and updated tech events')

      # TODO: Move fixture under spec/
      fixture = read_fixture('weekly_digest').join
      expect(fixture).to include(email.text_part.decoded)
      expect(fixture).to include(email.html_part.decoded)
    end
  end
end
