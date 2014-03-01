require 'spec_helper'

describe EventsController do
  before :each do
    @event = Event.create({ :twitter_handle => 'yolo' })
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

  describe 'PUT or PATCH update' do
    before :each do
      @user = User.create(:name => 'Lemon Grab', :email => 'lemongrab@castle.com', :password => "dungeon")
      subject.stub(:current_user) { @user }
      request.env["HTTP_REFERER"] = root_path
    end

    it 'requires user to be logged in'

    it 'should remove an event from a users list' do
      @user.events << @event
      expect(@user.events.count).to eq(1)
      put :update, { :id => @event.id, :commit => 'Remove' }
      expect(@user.events.count).to eq(0)
    end

    it 'should add an event to a  users list' do
      expect(@user.events.count).to eq(0)
      put :update, { :id => @event.id, :commit => 'Add' }
      expect(@user.events.count).to eq(1)
      expect(@user.events.first.twitter_handle).to eq(@event.twitter_handle)
    end

    it 'should redirect back on completion' do
      put :update, { :id => @event.id, :commit => 'Add' }
      expect(response.response_code).to be(302)
      expect(subject).to redirect_to(root_path)
    end
  end

end
