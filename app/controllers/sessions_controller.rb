class SessionsController < ApplicationController
  def create
    user = login(session_params[:email], session_params[:password], session_params[:remember_me])
    if user
      redirect_back_or_to root_url, :notice => "Welcome back #{user.name_or_email}!"
    else
      flash.now.alert = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, :notice => 'You have been logged out.'
  end

  private
  def session_params
    params.permit(:email, :password, :remember_me)
  end
end
