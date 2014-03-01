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
      request.env["HTTP_REFERER"] = root_path
    end

    it 'should change user name' do
      put :update, { :id => @user.id, :user => { :name => 'The Earl' } }
      expect(@user.name).to eq('The Earl')
    end

    it 'should change user email' do
      put :update, { :id => @user.id, :user => { :email => 'earl@castle.com' } }
      expect(@user.email).to eq('earl@castle.com')
    end

    it 'should not change user password' do
      # Rspec compares strings as symbols so we must .to_s it again
      expect{ put :update, { :id => @user.id, :user => { :password => 'lolhacked', :password_confirmation => 'lolhacked' } } }.to_not change{ @user.crypted_password.to_s }
    end
  end

  describe 'POST toggle_subscribed' do
    # TODO: Extract call to subject

    before :each do
      subject.stub(:current_user) { @user }
      request.env["HTTP_REFERER"] = root_url
    end

    it 'should unsubscribe a user' do
      expect{ post :toggle_subscribed }.to change{ @user.subscribed }.to be_false
    end

    it 'should subscribe a user' do
      @user.update_attribute(:subscribed, false)
      expect{ post :toggle_subscribed }.to change{ @user.subscribed }.to be_true
    end

    it 'should redirect back afterwards' do
      post :toggle_subscribed
      expect(subject).to redirect_to(root_url)
    end

    it 'should show a notice after subscribing' do
      @user.update_attribute(:subscribed, false)
      post :toggle_subscribed

      expect(flash[:notice]).to_not be_nil
      expect(flash[:notice]).to include('Subscribed')
    end

    it 'should show a notice after unsubscribing' do
      post :toggle_subscribed

      expect(flash[:notice]).to_not be_nil
      expect(flash[:notice]).to include('Unsubscribed')
    end
  end

  describe 'DELETE destroy' do
    before :each do
      subject.stub(:current_user) { @user }
    end
    it 'should delete a user' do
      expect{ delete :destroy, { :id => @user.id } }.to change{ User.count }.from(1).to(0)
    end

    it 'should redirect to root' do
      delete :destroy, { :id => @user.id }
      expect{ subject }.to redirect_to(root_url)
    end

    it 'should display a notice' do
      delete :destroy, { :id => @user.id }
      expect(flash[:notice]).to_not be_nil
      expect(flash[:notice]).to include('Goodbye')
    end
  end
end
