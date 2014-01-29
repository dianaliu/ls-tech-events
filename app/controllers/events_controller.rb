class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def export
    @events = Event.all
    respond_to do |format|
      format.json { render :json => @events.as_json }
      format.xml { render :xml => @events.as_json.to_xml }
    end
  end
end