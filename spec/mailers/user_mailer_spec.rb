require "spec_helper"

describe UserMailer do
  before :each do
    @user = User.create(:email => 'baggins@bagend.com', :password => 'precious')
    @email = UserMailer.confirm_signup(@user).deliver
  end

  describe ".confirm_signup" do
    it "sends an email" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end

    it "sends the correct content" do
      expect(@email.from).to include('no-reply@ls-tech-events.herokuapp.com')
      expect(@email.to).to include(@user.email)
      expect(@email.body.decoded).to include('Unsubscribe')
    end
  end
end
