class AdminsController < ApplicationController
  before_action :ensure_admin
  before_action :set_admin, only: [:destroy]

  def index
    @admins = User.where(role: 'admin').order(:name)
  end

  def new
    @admin = User.new
  end

  def create
   @admin = User.new(admin_params)
    @admin.role = 'admin'
    if @admin.save
      redirect_to admins_path, notice: "Administrador creado exitosamente."
    else
      render :new
    end
  end

  def destroy
    if @admin != current_user && User.where(role: 'admin').count > 1
      @admin.destroy
      redirect_to admins_path, notice: 'Administrador eliminado exitosamente.'
    else
      redirect_to admins_path, alert: 'No se puede eliminar este administrador.'
    end
  end

  private

  def admin_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_admin
    @admin = User.find(params[:id])
  end
end
