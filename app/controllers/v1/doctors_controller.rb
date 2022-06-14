class V1::DoctorsController < ApplicationController
  before_action :authorize_request, only: %i[index show create destroy]

  def index
    @response = []
    @doctors = Doctor.all
    @serialized_doctors = DoctorSerializer.new(@doctors).serializable_hash[:data]

    if @serialized_doctors.empty?
      render json: { error: 'not found', error_message: ['No doctors found'] }, status: :not_found
    else
      @serialized_doctors.each do |doctor|
        @response << {
          id: doctor[:id],
          name: doctor[:attributes][:name],
          city: doctor[:attributes][:city],
          specialization: doctor[:attributes][:specialization],
          costPerDay: doctor[:attributes][:cost_per_day],
          description: doctor[:attributes][:description],
          imageUrl: doctor[:attributes][:image_url]
        }
      end
      render json: { data: @response, message: ['All doctors loaded'] }, status: :ok
    end
  end

  def show
    @doctor = Doctor.find(params[:id])
    render json: DoctorSerializer.new(@doctor).serializable_hash[:data][:attributes], status: :ok
  end

  def create
    if @current_user.role == 'admin'
      @doctor = Doctor.new(doctor_params)
      if @doctor.save
        render json: DoctorSerializer.new(@doctor).serializable_hash[:data][:attributes], status: :created
      else
        render json: @doctor.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'unauthorized', error_message: 'you need admin permision' }, status: :unauthorized
    end
  end

  def destroy
    if @current_user.role == 'admin'
      @doctor = Doctor.find(params[:id])
      @doctor.destroy
      render json: { message: 'Doctor deleted successfully' }, status: :ok
    else
      render json: { error: 'unauthorized', error_message: 'you need admin permision' }, status: :unauthorized
    end
  end

  private

  def doctor_params
    params.require(:doctor).permit(:name, :specialization, :city, :description, :cost_per_day, :image, :image_url)
  end
end
