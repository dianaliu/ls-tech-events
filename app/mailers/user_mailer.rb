class UserMailer < ActionMailer::Base
  require 'mandrill'

  def confirm_signup(user)
    # TODO: Send with mandrill, unsubscribe link
    @user = user
    @events = Event.all.sample(3) if @user.events.empty?
    mail(to: @user.email, subject: 'ls tech-events: Signup Confirmed')
  end

  def events_reminder(user)
    return false if !user.subscribed?
    return false if user.events.upcoming.empty?

    # Sort recent events on top. Nil dates are most recent.
    # TODO: Sort :asc with nulls on bottom, see http://stackoverflow.com/questions/5520628/rails-sort-nils-to-the-end-of-a-scope
    @events = user.events.upcoming.order(start_date: :asc)

    mandrill = Mandrill::API.new
    result = mandrill.messages.send_template(
      template_name='Events Reminder',
      template_content=[{ :name => 'not used', :content => 'placeholder' }],
      message={
        :to => [{ :email => user.email, :name => user.name_or_email }],
        :auto_text => true,
        :merge_vars => [{
          :rcpt => user.email,
          :vars => [{
            :name => 'RECENT_EVENTS_CONTENT',
            :content => render_to_string(:partial => 'events_reminder', :layout => false, :locals => { :events => @events })
          },
          {
            :name => 'UPDATE_PROFILE',
            :content => user_url(user)
          },
          {
            :name => 'UNSUB',
            :content => user_url(user)
          }]
        }]
      })
    user.update_attribute(:last_reminder_date, Date.today) if ['sent', 'queued'].include?(result[0].as_json['status'])
  end

end
