class InstallationsController < ApplicationController
  def start
    @installation.update(status: 'in_progress')
    redirect_to @installation, notice: 'Instalación iniciada.'
  end

  def finish
    Rails.logger.debug "Finish params: #{params.inspect}"
    duration_hours = params[:duration_hours].to_f
    Rails.logger.debug "Duration hours: #{duration_hours}"
    if duration_hours > 0
      @installation.update(status: 'completed')
      redirect_to @installation, notice: 'Instalación finalizada.'
    else
      redirect_to @installation, alert: "Debe ingresar una duración válida mayor a 0 horas. Recibido: #{params[:duration_hours]}"
    end
  end
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_installation, only: [:show, :edit, :update, :destroy, :complete, :cancel, :start, :finish]

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
    Rails.logger.error "[DEBUG] update action params: #{params.inspect}"
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
    Rails.logger.error "[DEBUG] assign action params: #{params.inspect}"
    installation = Installation.find(params[:installation_id])
    technician = Technician.find(params[:technician_id])
    installation.technician = technician
    installation.status = 'assigned'
    if installation.save
      redirect_to technician_path(technician), notice: 'Instalación asignada exitosamente.'
    else
      redirect_to technician_path(technician), alert: installation.errors.full_messages.join(', ')
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
                                       :scheduled_date, :scheduled_time, :notes)
  end
end
