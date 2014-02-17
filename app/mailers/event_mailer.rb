class EventMailer < ActionMailer::Base
  require 'mandrill'

  def weekly_digest(changes)
    @admin = ENV['ADMIN_EMAIL']
    @changes = changes
    mail(to: @admin, subject: 'New and updated tech events')
  end
end
