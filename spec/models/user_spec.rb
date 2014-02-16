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
end
