class UsersController < ApplicationController
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

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end