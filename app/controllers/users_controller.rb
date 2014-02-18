class UsersController < ApplicationController
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
    current_user.update_attributes(params[:user])

    event = Event.find(params[:user][:events][:id])
    if params[:user][:events][:add].to_i.zero?
      current_user.events.delete(event)
    else
      current_user.events << event
    end
    redirect_to :back
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end