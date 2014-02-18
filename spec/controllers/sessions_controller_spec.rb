require 'spec_helper'

describe SessionsController do
  before :each do
    @password = 'secret'
    @user = User.create(:email => 'tina@butts.com', :password => @password)
  end

  describe 'POST create' do
    it 'should log a user in' do
      post :create, { :email => @user.email, :password => @password }
      expect(controller.logged_in?).to eq(true)
      expect(controller.current_user.email).to eq(@user.email)
    end

    it 'should log in and redirect to root' do
      post :create, { :email => @user.email, :password => @password }
      expect(controller).to redirect_to(root_url)
    end

    it 'should log in and redirect back' do
      # Sorcery uses session, not the request to redirect
      # request.env["HTTP_REFERER"] = '/about'
      session[:return_to_url] = '/about'
      post :create, { :email => @user.email, :password => @password }
      expect(controller).to redirect_to('/about')
    end

    it 'should log in and show a notice' do
      post :create, { :email => @user.email, :password => @password }
      expect(flash[:notice]).to_not be_empty
      expect(flash[:notice]).to include('Welcome back')
      expect(flash[:notice]).to include(@user.name_or_email)
    end

    it 'should not log in a bad email' do
      post :create, { :email => 'NOPE', :password => 'WRONG' }
      expect(controller.logged_in?).to eq(false)
    end

    it 'should not log in a bad password' do
      post :create, { :email => 'cactus@desert.com', :password => @password }
      expect(controller.logged_in?).to eq(false)
    end

    it 'should re-render a bad login' do
      post :create, { :email => @user.email, :password => 'WRONG' }
      expect(controller).to render_template(:new)
    end

    it 'should alert a bad login' do
      post :create, { :email => @user.email, :password => 'WRONG' }
      expect(flash[:alert]).to_not be_empty
      expect(flash[:alert]).to include('Invalid email or password')
    end
  end

  describe 'GET destroy' do
    before :each do
      login_user
    end

    it 'logs the user out' do
      get :destroy
      expect(controller.logged_in?).to eq(false)
    end

    it 'redirects after log out' do
      get :destroy
      expect(controller).to redirect_to(root_url)
    end

    it 'shows notice after log out' do
      get :destroy
      expect(flash[:notice]).to_not be_empty
      expect(flash[:notice]).to include('You have been logged out')
    end
  end
end
