class CatsController < ApplicationController

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
    @params = {name: @cat.name, age: @cat.age, birth_date: @cat.birth_date,               color: @cat.color, sex: @cat.sex}
    @colors = Cat.cat_colors
    render :edit
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
    if @cat.save
      @cats = Cat.all
      redirect_to cats_url
    else
      render :new
    end
  end
end
