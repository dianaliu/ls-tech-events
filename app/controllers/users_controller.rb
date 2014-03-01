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

  def toggle_subscribed
    current_user.toggle!(:subscribed)
    notice = current_user.subscribed? ? "Subscribed: You will receive event reminders again." : "Unsubscribed: You will not receive any more event reminders."
    redirect_to :back, :notice => notice
  end

  def destroy
    current_user.destroy
    redirect_to root_url, :notice => 'You have deleted your account. Goodbye!'
  end

  private

  def update_user_params
    params.require(:user).permit(:name, :email)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end