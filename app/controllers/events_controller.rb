class EventsController < ApplicationController
  def index
    # Hm, do we still want this to be root
    @events = Event.all
    @user = User.new
  end

  def show
    @event = Event.find(params[:id])
  end

  def update
    # TODO: Change what users follow an event
  end

  def export
    @events = Event.all
    respond_to do |format|
      format.json { render :json => @events.as_json }
      format.xml { render :xml => @events.as_json.to_xml }
    end
  end

  private

  def event_params
    # For a single resource
  end

  def events_params
    # For a collection of events
  end
end