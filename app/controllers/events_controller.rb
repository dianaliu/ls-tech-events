class EventsController < ApplicationController
  def index
    @events = Event.all
    @user = User.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def update
    event = Event.find(params[:id])

    if params[:commit].downcase == 'add'
      event.users << current_user
    elsif params[:commit].downcase == 'remove'
      event.users.delete(current_user)
    end

    redirect_to :back
  end

  def export
    @events = Event.all
    respond_to do |format|
      format.json { render :json => @events.as_json }
      format.xml { render :xml => @events.as_json.to_xml }
    end
  end
end