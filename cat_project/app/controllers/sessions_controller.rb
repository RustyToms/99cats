class SessionsController < ApplicationController

skip_before_filter :check_owner

  def create
    @user = User.find_by_credentials(params[:user_name], params[:password])

    if @user = nil
      flash[:error] = "Invalid user_name or password.  Please try again."
      render :new
    else
      @user.reset_session_token!
      self.current_user = @user
      redirect_to cats_url
    end
  end

  def new
    render :new
  end

  def destroy
    # blank out the cookie?
    current_user.reset_session_token!
    redirect_to cats_url

  end


end
