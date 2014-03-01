require 'spec_helper'

describe UsersController do
  before :each do
   @user = User.create(:name => 'Lemon Grab', :email => 'lemongrab@castle.com', :password => "dungeon")
  end

  describe 'POST create' do
    subject { post :create, :user => { :name => @user.name, :email => @user.email, :password => "dungeon" } }

    it 'assigns @user' do
      subject do
        expect(assigns(:user).name).to eq(@user.name)
        expect(assigns(:user).email).to eq(@user.email)
      end
    end

    it 'redirects to root on success' do
      subject do
        expect(assigns(:user).errors).to be_nil
        expect(subject).to redirect_to(root_url)
      end
    end

    it 'shows flash notice with name on success' do
      subject do
        expect(flash[:notice]).to_not be_nil
        expect(flash[:notice]).to include(@user.name)
      end
    end

    it 'shows flash notice with email on success' do
      @user.update_attribute(:name, nil)
      subject do
        expect(flash[:notice]).to_not be_nil
        expect(flash[:notice]).to include(@user.email)
      end
    end

    it 'sends an email on success' do
      subject do
        expect(ActionMailer::Base.deliveries).to_not be_empty
        expect(ActionMailer::Base.deliveries.last.to).to include(@user.email)
      end
    end

    it 'logs the user in on success' do
      subject do
        expect(current_user).to be_true
      end
    end

    it 'shows form and errors on error' do
      @user.update_attribute(:email, nil)
      subject do
        expect(flash[:alert]).to_not be_nil
        expect(flash[:alert]).to include(@user.errors.full_message)
        expect(subject).to render_template(:new)
      end
    end
  end

  describe 'GET new' do
    it "assigns @user" do
      get :new
      expect(assigns(:user).new_record?).to eq(true)
    end
  end

  describe 'GET show' do
    it "assigns @user" do
      get :show, { :id => @user.id }
      expect(assigns(:user).id).to eq(@user.id)
      expect(assigns(:user).name).to eq(@user.name)
    end
  end

  describe 'PUT or PATCH update' do
    before :each do
      subject.stub(:current_user) { @user }
      @event = Event.create(:twitter_handle => '@snowfall')
      request.env["HTTP_REFERER"] = root_path
    end

    it 'requires user to be logged in'

    it 'should remove an event from a users list' do
      @user.events << @event
      expect(@user.events.count).to eq(1)
      put :update, { :id => @user.id, :user => { :events => { :id => @event.id, :add => 0 } }  }
      expect(@user.events.count).to eq(0)
    end

    it 'should add an event to a  users list' do
      expect(@user.events.count).to eq(0)
      put :update, { :id => @user.id, :user => { :events => { :id => @event.id, :add => 1 } }  }
      expect(@user.events.count).to eq(1)
      expect(@user.events.first.twitter_handle).to eq(@event.twitter_handle)
    end

    it 'should redirect back on completion' do
      put :update, { :id => @user.id, :user => { :events => { :id => @event.id, :add => 1 } }  }
      expect(response.response_code).to be(302)
      expect(subject).to redirect_to(root_path)
    end
  end

  describe 'POST edit' do
    pending
  end

  describe 'POST destroy' do
    pending
  end
end
