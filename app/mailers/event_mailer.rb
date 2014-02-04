class EventMailer < ActionMailer::Base
  require 'mandrill'

  def weekly_digest(changes)
    @admin = ENV['ADMIN_EMAIL']
    @changes = changes
    mail(to: @admin, subject: 'New and updated tech events')
  end

  def user_digest(events=nil)
    @events = events || Event.where(:start_date => Date.today + 3.months..Date.today + 6.months)
    # Most far away first (nils end up on bottom)
    # TODO: Sort :asc with nulls on bottom, see http://stackoverflow.com/questions/5520628/rails-sort-nils-to-the-end-of-a-scope
    @events = @events.order(start_date: :desc)

    mandrill = Mandrill::API.new
    mandrill.messages.send_template(
      template_name='User Digest',
      template_content=[{ :name => 'not used', :content => 'placeholder' }],
      message={
        :to => [{ :email => ENV['ADMIN_EMAIL'], :name => 'Diana' }],
        :auto_text => true,
        :merge_vars => [{
          :rcpt => 'diana.g.liu@gmail.com',
          :vars => [{
            :name => 'RECENT_EVENTS_CONTENT',
            :content => render_to_string(:partial => 'user_digest', :layout => false, :locals => { :events => @events })
          }]
        }]
      }) if @events
  end

end
