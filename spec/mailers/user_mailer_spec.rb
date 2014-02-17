require "spec_helper"

describe UserMailer do
  before :each do
    @user = User.create(:email => 'baggins@bagend.com', :password => 'precious')
  end

  describe ".confirm_signup" do
    before :each do
      @email = UserMailer.confirm_signup(@user).deliver
    end

    it "sends an email" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it "sends the correct content" do
      expect(@email.from).to include('no-reply@ls-tech-events.herokuapp.com')
      expect(@email.to).to include(@user.email)
      expect(@email.body.decoded).to include('Unsubscribe')
    end
  end

  describe ".events_reminder" do
    before :each do
      @upcoming_event = Event.create(:twitter_handle => 'Lothlórien', :start_date => 2.months.from_now)
    end

    it "does not email when user has no upcoming events" do
      expect(@user.events.upcoming).to be_empty
      expect(Mandrill::API).to_not receive(:new)

      UserMailer.events_reminder(@user).deliver
    end

    it "emails when user has upcoming events" do
      @user.events << @upcoming_event
      expect(@user.events.upcoming).to_not be_empty

      expect_any_instance_of(Mandrill::Messages).to receive(:send_template).and_call_original

      UserMailer.events_reminder(@user).deliver
    end

    it "updates users's last_reminder_date" do
      @user.events << @upcoming_event
      expect(@user.events.upcoming).to_not be_empty

      Mandrill::Messages.any_instance.stub(:send_template).and_return([{ 'status' => 'sent' }])
      expect(@user).to receive(:update_attribute).and_call_original

      UserMailer.events_reminder(@user).deliver
    end

    it "emails the right content" do
      @user.events << @upcoming_event
      # expect(@user.events.upcoming).to_not be_empty

      pending "Check the partial and Mandrill template"
    end
  end
end
