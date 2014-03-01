class UsersController < ApplicationController
  # TODO: Does a redirect to root. Any way to modify behavior?
  before_action :require_login, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.errors.any?
      flash.now.alert = "Error signing up: " + @user.errors.full_messages.join(", ")
      render :new
    else
      UserMailer.confirm_signup(@user).deliver
      auto_login(@user, true)
      redirect_to root_url, notice: "Thanks #{@user.name_or_email}! You'll see an email from us soon."
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    # TODO: only for current_user
    # current_user.update_attributes(params[:user])


    # TODO: Move into events controller
    # Receives a single id or an array of ids
    # Must convert to an array of ints
    event_ids = params[:user][:events][:id]
    event_ids = event_ids.include?("[") ? event_ids[1..-2].split(', ') : [event_ids.to_i]

    events = Event.find(event_ids)
    events.each do |event|
      if params[:user][:events][:add].to_i.zero?
        current_user.events.delete(event)
      else
        current_user.events << event
      end
    end

    redirect_to :back
  end

  def unsubscribe
    current_user.unsubscribe_from_reminders
    redirect_back_or_to root_url, :notice => "Unsubscribed: You will not receive any more event reminders."
  end

  def subscribe
    current_user.subscribe_to_reminders
    redirect_back_or_to root_url, :notice => "Subscribed: You will receive event reminders again."
  end

  def edit
    # redirect_to :back
    # redirect_back_or_to
    # Only for current_user
  end

  def destroy
    # only for current_user
  end

  private

  def user_params
    # params.require(:user).permit(:name, :email, :password, :events => [:id], :password_confirmation)
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end