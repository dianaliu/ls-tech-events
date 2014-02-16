class UserMailer < ActionMailer::Base
  require 'mandrill'

  def confirm_signup(user)
    # TODO: Send with mandrill, unsubscribe link, edit link
    @user = user
    @events = Event.all.sample(3) if @user.events.empty?
    mail(to: @user.email, subject: 'ls tech-events: Signup Confirmed')
  end

end
