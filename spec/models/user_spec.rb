require 'spec_helper'

describe User do
  describe '.create' do
    it 'creates with an email and password' do
      expect{ User.create(:email => 'murray-arty@sesame-street.com', :password => '221bakerst') }.to change{ User.count }.by(1)
    end

    it 'does not create with a name' do
      expect{ User.create!(:name => 'Benedict Cumberbatch')}.to raise_error
      expect{ User.create(:name => 'Benedict Cumberbatch')}.to_not change{ User.count }
    end

    it 'does not create duplicate emails' do
      email = 'benedict@sherlock.com'
      password = 'sammys'
      user = User.create(:email => email, :password => password)
      expect{ User.create(:email => email, :password => password) }.to_not change{ User.count }
    end
  end

  describe '#name_or_email' do
    it 'returns name when present' do
      user = User.create(:name => 'ariel', :email => 'ariel@the-sea.com')
      expect(user.name_or_email).to eq(user.name)
    end

    it 'returns email when no name' do
      user = User.create(:email => 'ariel@the-sea.com')
      expect(user.name_or_email).to eq(user.email)
    end
  end

  describe '#events.upcoming' do
    before :each do
      @user = User.create(:email => 'lestrade@gmail.com', :password => 'bollocks')
      @event = Event.create(:twitter_handle => '@mi6')
    end

    it 'does not return past events' do
      @event.update_attribute(:start_date, 1.month.ago)
      @user.events << @event
      expect(@user.events.upcoming).to be_empty

    end

    it 'does not return far future events' do
      @event.update_attribute(:start_date, 5.months.from_now)
      @user.events << @event
      expect(@user.events.upcoming).to be_empty
    end

    it 'returns events in the next 3 months' do
      @event.update_attribute(:start_date, 3.months.from_now.end_of_month)
      @user.events << @event
      expect(@user.events.upcoming).to_not be_empty
      expect(@user.events.upcoming.first.id).to eq(@event.id)
    end
  end
end
