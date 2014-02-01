class EventMailer < ActionMailer::Base

  def weekly_digest(changes)
    @admin = "diana.g.liu@gmail.com"
    @changes = changes
    mail(to: @admin, subject: 'New and updated tech events')
  end
end
