
class UsersController < ApplicationController

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new
    @user.user_name = params[:user][:user_name]
    @user.password = params[:user][:password]
    puts "USER STUFF"
    p @user
    if @user.save
      self.current_user = @user
      redirect_to user_url(@user)
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private

  def show
    @user = User.find_by_credentials(params[:user_name], params[:password])
    render :show
  end

end
