class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @date = params[:date]&.to_date || Date.current
    @installations = Installation.includes(:technician)
                                .for_date(@date)
                                .order(:start_time)
    @technicians = Technician.active.order(:name)
  end

  def show
    @technician = Technician.find(params[:id])
    @date = params[:date]&.to_date || Date.current
    @installations = @technician.installations
                               .for_date(@date)
                               .order(:start_time)
  end
end
