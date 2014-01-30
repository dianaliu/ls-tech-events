require 'spec_helper'

describe EventsController do
  before :each do
    @event = Event.create({ :name => 'yolo' })
  end

  describe 'GET index' do
    it 'assigns @events' do
      get :index
      expect(assigns(:events)).to eq([@event])
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    it 'assigns @event' do
      get :show, { :id => @event.id }
      expect(assigns(:event)).to eq(@event)
    end

    it 'renders show template' do
      get :show, { :id => @event.id }
      expect(response).to render_template('show')
    end
  end

  describe 'GET export' do
    it 'assigns @events' do
      get :export, { :format => 'json' }
      expect(assigns(:events)).to eq([@event])
    end

    it 'renders json' do
      get :export, { :format => 'json' }
      expect(JSON.parse(response.body)).to eq([@event.as_json.stringify_keys!])
    end

    it 'renders xml' do
      get :export, { :format => 'xml' }
      expect(response.body).to eq([@event].as_json.to_xml)
    end
  end

end
