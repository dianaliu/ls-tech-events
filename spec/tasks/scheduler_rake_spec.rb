require 'spec_helper'
require 'rake'

describe 'scheduler rake task' do
  # before :all do
  #   Rake.application.rake_require "tasks/scheduler"
  #   Rake::Task.define_task(:environment)
  # end

  # describe "update_from_twitter" do
  #   let :run_rake_task do
  #     Rake::Task['update_from_twitter'].reenable
  #     Rake.application.invoke_task 'update_from_twitter'
  #   end

  #   it 'should email when there are changes on Friday' do
  #     Time.stub_chain(:now, :friday?).and_return(:true)

  #     # FIXME: Both sides fail with cryptic messages
  #     # expect{ run_rake_task }.to change{ ActionMailer::Base.deliveries.size }.by(1)

  #     pending "Fix rake environment bugs"
  #   end

  #   it 'should not email when there are no changes' do
  #     pending "Fix rake environment bugs"
  #   end
  # end

  # describe "remind_users" do
  #   pending
  # end
end