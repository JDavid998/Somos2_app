class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_admin
  
  def index
    if user_signed_in? && current_user.admin?
      redirect_to dashboard_path
    else
      # Dashboard público para técnicos - mostrar todas las instalaciones
      @today_installations = Installation.for_date(Date.current)
                                        .includes(:technician)
                                        .order(:scheduled_time)
      
      @upcoming_installations = Installation.where(scheduled_date: Date.current..1.week.from_now)
                                           .where(status: ['pending', 'assigned', 'in_progress'])
                                           .includes(:technician)
                                           .order(:scheduled_date, :scheduled_time)
      
      @pending_count = Installation.where(status: 'assigned').count
      @in_progress_count = Installation.where(status: 'in_progress').count
      @completed_today = Installation.where(status: 'completed')
                                    .for_date(Date.current)
                                    .count
      @total_technicians = Technician.active.count
    end
  end
end
