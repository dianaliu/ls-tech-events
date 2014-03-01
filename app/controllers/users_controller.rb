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
    current_user.update_attributes(update_user_params)
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

  def destroy
    # only for current_user
  end

  private

  def update_user_params
    params.require(:user).permit(:name, :email)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end