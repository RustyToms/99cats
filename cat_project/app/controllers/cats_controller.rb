class CatsController < ApplicationController

  before_filter :check_owner, except: [:show, :index, :new]
  skip_before_filter :check_login, only: [:index, :show]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.includes(:requests).find(params[:id])
    render :show
  end

  def new
    @params = {}
    @colors = Cat.cat_colors
    render :new
  end

  def edit
    @cat = Cat.find(params[:id])

    # if current_user.nil? || current_user.id != @cat.user_id
    #   flash[:errors] = "Cannot edit a cat that you don't own."
    #   redirect_to cat_url(params[:id])
    # else
      @params = {name: @cat.name, age: @cat.age, birth_date: @cat.birth_date,
        color: @cat.color, sex: @cat.sex}
      @colors = Cat.cat_colors
      render :edit
    # end
  end

  def update
    @params = params[:cat]
    @cat = Cat.find(params[:id])
    @colors = Cat.cat_colors
    if @cat.update_attributes(@params)
      @cats = Cat.all
      redirect_to cats_url
    else
      render :edit
    end
  end

  def create
    @params = params[:cat]
    @cat = Cat.new(params[:cat])
    @colors = Cat.cat_colors
    @cat.user_id = current_user
    if @cat.save
      @cats = Cat.all
      redirect_to cats_url
    else
      render :new
    end
  end

  private

  def check_owner
    unless Cat.find(params[:id]).user_id == current_user.id
      flash[:errors] = "You must be logged in as the owner of this cat to do that."
      redirect_to cat_url(params[:id])
    end
  end


end
