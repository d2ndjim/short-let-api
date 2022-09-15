class HallsController < ApplicationController
  before_action :set_hall, only: %i[ show update destroy ]

  # GET /halls
  def index
    @halls = Hall.all

    render json: @halls
  end

  # GET /halls/1
  def show
    render json: @hall
  end

  # POST /halls
  def create
    @hall = Hall.new(hall_params)

    if @hall.save
      render json: @hall, status: :created, location: @hall
    else
      render json: @hall.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /halls/1
  def update
    if @hall.update(hall_params)
      render json: @hall
    else
      render json: @hall.errors, status: :unprocessable_entity
    end
  end

  # DELETE /halls/1
  def destroy
    @hall.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hall
      @hall = Hall.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hall_params
      params.require(:hall).permit(:name, :capacity, :cost, :image, :description)
    end
end
