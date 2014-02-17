class UserMailer < ActionMailer::Base
  require 'mandrill'

  def confirm_signup(user)
    # TODO: Send with mandrill, unsubscribe link, edit link
    @user = user
    @events = Event.all.sample(3) if @user.events.empty?
    mail(to: @user.email, subject: 'ls tech-events: Signup Confirmed')
  end

  def events_reminder(user, events)
    return false if events.empty?

    # Most far away first (nils end up on bottom)
    # TODO: Sort :asc with nulls on bottom, see http://stackoverflow.com/questions/5520628/rails-sort-nils-to-the-end-of-a-scope
    @events = events.order(start_date: :desc)

    mandrill = Mandrill::API.new
    mandrill.messages.send_template(
      template_name='User Digest',
      template_content=[{ :name => 'not used', :content => 'placeholder' }],
      message={
        :to => [{ :email => user.email, :name => user.name_or_email }],
        :auto_text => true,
        :merge_vars => [{
          :rcpt => user.email,
          :vars => [{
            :name => 'RECENT_EVENTS_CONTENT',
            :content => render_to_string(:partial => 'user_digest', :layout => false, :locals => { :events => @events })
          }]
        }]
      })
    user.update_attribute(:last_reminder_date, Date.today)
  end

end
