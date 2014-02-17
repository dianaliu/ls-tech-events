require 'spec_helper'
require 'rake'

describe 'scheduler rake task' do
  before :all do
    Rake::Task.define_task(:environment)
    LsTechEvents::Application.load_tasks
  end

  describe "update_from_twitter" do
    let :run_rake_task do
      Rake::Task['update_from_twitter'].reenable
      Rake.application.invoke_task 'update_from_twitter'
    end

    it 'should email when there are changes on a Friday' do
      Twitter::REST::Client.any_instance.stub(:list_members).and_return(JSON.parse(File.read('test/fixtures/tasks/update_from_twitter')))

      Time.any_instance.stub(:friday?).and_return(true)
      expect(Time.now.friday?).to eq(true)

      expect(EventMailer).to receive(:weekly_digest).and_call_original
      expect{ run_rake_task }.to change{ Event.count }.by(1)
    end

    it 'should not email when there are no changes' do
      Twitter::REST::Client.any_instance.stub(:list_members).and_return([])

      Time.any_instance.stub(:friday?).and_return(true)
      expect(Time.now.friday?).to eq(true)

      expect(EventMailer).to_not receive(:weekly_digest)
      expect{ run_rake_task }.to_not change{ Event.count }
    end

    it 'should not email when not a Friday' do
      expect(Twitter::REST::Client).to_not receive(:new)
      run_rake_task
    end
  end

  describe "remind_users" do
    let :run_rake_task do
      Rake::Task['remind_users'].reenable
      Rake.application.invoke_task 'remind_users'
    end

    it "should run on the first day of the month" do
      Date.any_instance.stub(:beginning_of_month).and_return(Date.today)
      expect(User).to receive(:where).exactly(2).times.and_call_original
      run_rake_task
    end

    it "should not run at any other time" do
      Date.any_instance.stub(:beginning_of_month).and_return(Date.new(1356, 2, 15))
      expect(User).to_not receive(:where)
      run_rake_task
    end

    it "should email users who need a reminder" do
      Date.any_instance.stub(:beginning_of_month).and_return(Date.today)

      User.stub(:where).and_return([User.create(:email => 'lestrade@gmail.com', :password => 'sherlocked')])
      expect(UserMailer).to receive(:events_reminder).and_call_original

      run_rake_task
    end
  end
end