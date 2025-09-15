class InstallationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_installation, only: [:show, :edit, :update, :destroy, :assign, :complete, :cancel]

  def index
    @installations = Installation.includes(:technician).order(scheduled_date: :desc)
    @installations = @installations.where(status: params[:status]) if params[:status].present?
  end

  def show
  end

  def new
    @installation = Installation.new
    @technicians = Technician.active.order(:name)
  end

  def create
    @installation = Installation.new(installation_params)
    @installation.status = 'pending'
    
    if @installation.save
      redirect_to @installation, notice: 'Instalación creada exitosamente.'
    else
      @technicians = Technician.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @technicians = Technician.active.order(:name)
  end

  def update
    if @installation.update(installation_params)
      redirect_to @installation, notice: 'Instalación actualizada exitosamente.'
    else
      @technicians = Technician.active.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @installation.destroy
    redirect_to installations_url, notice: 'Instalación eliminada exitosamente.'
  end

  def assign
    if params[:technician_id].present?
      @installation.technician_id = params[:technician_id]
      @installation.status = 'assigned'
      
      if @installation.save
        redirect_to @installation, notice: 'Técnico asignado exitosamente.'
      else
        redirect_to @installation, alert: @installation.errors.full_messages.join(', ')
      end
    else
      redirect_to @installation, alert: 'Debe seleccionar un técnico.'
    end
  end

  def complete
    @installation.update(status: 'completed')
    redirect_to @installation, notice: 'Instalación marcada como completada.'
  end

  def cancel
    @installation.update(status: 'cancelled', technician: nil)
    redirect_to @installation, notice: 'Instalación cancelada.'
  end

  private

  def set_installation
    @installation = Installation.find(params[:id])
  end

  def installation_params
    params.require(:installation).permit(:customer_name, :customer_address, :customer_phone, 
                                       :scheduled_date, :start_time, :duration_hours, :notes)
  end
end
