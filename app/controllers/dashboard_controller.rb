class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @pending_count = Installation.pending.count
    @active_technicians_count = Technician.active.count
    @today_installations_count = Installation.for_date(Date.current).count
    @completed_this_month_count = Installation.completed
                                             .where(updated_at: Date.current.beginning_of_month..Date.current.end_of_month)
                                             .count
    
    # Filtros para gráficas
    @selected_technician = params[:technician_id].present? ? Technician.find(params[:technician_id]) : nil
    @date_range = params[:date_range] || '30_days'
    
    # Configurar rango de fechas
    case @date_range
    when '7_days'
      start_date = 7.days.ago
      end_date = Date.current
    when '30_days'
      start_date = 30.days.ago
      end_date = Date.current
    when '90_days'
      start_date = 90.days.ago
      end_date = Date.current
    else
      start_date = 30.days.ago
      end_date = Date.current
    end
    
    # Base query para instalaciones
    installations_query = Installation.where(scheduled_date: start_date..end_date)
    installations_query = installations_query.where(technician: @selected_technician) if @selected_technician
    
    @installations_by_day = installations_query.group(:scheduled_date).count
    
    # Gráfica de estados de instalaciones
    @installations_by_status = installations_query.group(:status).count
    
    # Gráfica de instalaciones por técnico (top 10)
    @installations_by_technician = Installation.joins(:technician)
                                              .where(scheduled_date: start_date..end_date)
                                              .group('technicians.name')
                                              .count
                                              .sort_by { |k, v| -v }
                                              .first(10)
                                              .to_h

    # Lista de técnicos para el filtro
    @all_technicians = Technician.active.order(:name)

    # Próximas instalaciones (próximas 2 semanas)
    schedule_start_date = Date.current
    schedule_end_date = 2.weeks.from_now
    
    @weekly_schedule = Installation.includes(:technician)
                                  .where(status: ['pending', 'assigned', 'in_progress'])
                                  .where(scheduled_date: schedule_start_date..schedule_end_date)
                                  .order(:scheduled_date, :scheduled_time)
                                  .group_by { |installation| installation.technician || "Sin asignar" }
  end
end
