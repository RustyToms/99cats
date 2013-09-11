class CatRentalRequestsController < ApplicationController

  def new
    @cats = Cat.all
    params[:request] ||= {}
    @request = CatRentalRequest.new(params[:request])
    render :new
  end

  def create
    new_request = CatRentalRequest.new(params[:cat_rental_request])

    if new_request.save
      redirect_to cat_url(new_request.cat_id)
    else
      @cats = Cat.all
      @request = new_request
      render :new
    end
  end
end
