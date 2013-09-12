class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery

  before_filter :check_login

  private

  def check_login
    if current_user.nil?
      flash[:errors] = "Please log in or sign up to see that content."
      redirect_to new_user_url
    end
  end
end
