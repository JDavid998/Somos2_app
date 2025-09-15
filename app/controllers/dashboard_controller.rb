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
    
    # Datos para gráficos - expandir rango para incluir más datos
    @installations_by_day = Installation.group(:scheduled_date)
                                       .where(scheduled_date: 2.months.ago..2.weeks.from_now)
                                       .count
                                       
    @technicians_by_day = Installation.joins(:technician)
                                     .where.not(technician_id: nil)
                                     .where(scheduled_date: 2.months.ago..2.weeks.from_now)
                                     .group('technicians.name')
                                     .count

    # DEBUG: Agregar temporalmente para ver los datos
   
  end
end
