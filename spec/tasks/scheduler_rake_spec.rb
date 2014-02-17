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

      expect(EventMailer).to receive(:weekly_digest).and_return( double("Mailer", :deliver => true) )
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
    pending
  end
end