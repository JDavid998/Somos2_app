class TechniciansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_technician, only: [:show, :edit, :update, :destroy]

  def index
    @technicians = Technician.order(:name)
  end

  def show
    @installations = @technician.installations.order(scheduled_date: :desc).limit(10)
  end

  def new
    @technician = Technician.new
  end

  def create
    @technician = Technician.new(technician_params)
    
    if @technician.save
      redirect_to @technician, notice: 'Técnico creado exitosamente.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @technician.update(technician_params)
      redirect_to @technician, notice: 'Técnico actualizado exitosamente.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @technician.installations.exists?
      redirect_to @technician, alert: 'No se puede eliminar un técnico con instalaciones asignadas.'
    else
      @technician.destroy
      redirect_to technicians_url, notice: 'Técnico eliminado exitosamente.'
    end
  end

  private

  def set_technician
    @technician = Technician.find(params[:id])
  end

  def technician_params
    params.require(:technician).permit(:name, :email, :phone, :active)
  end
end
