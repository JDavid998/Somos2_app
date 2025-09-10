class InstalacionesController < ApplicationController
  before_action :set_instalacion, only: %i[ show edit update destroy ]

  # GET /instalaciones or /instalaciones.json
  def index
    @instalaciones = Instalacion.all
  end

  # GET /instalaciones/1 or /instalaciones/1.json
  def show
  end

  # GET /instalaciones/new
  def new
    @instalacion = Instalacion.new
  end

  # GET /instalaciones/1/edit
  def edit
  end

  # POST /instalaciones or /instalaciones.json
  def create
    @instalacion = Instalacion.new(instalacion_params)

    respond_to do |format|
      if @instalacion.save
        format.html { redirect_to @instalacion, notice: "Instalacion was successfully created." }
        format.json { render :show, status: :created, location: @instalacion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instalacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instalaciones/1 or /instalaciones/1.json
  def update
    respond_to do |format|
      if @instalacion.update(instalacion_params)
        format.html { redirect_to @instalacion, notice: "Instalacion was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @instalacion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instalacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instalaciones/1 or /instalaciones/1.json
  def destroy
    @instalacion.destroy!

    respond_to do |format|
  format.html { redirect_to instalaciones_path, notice: "Instalación eliminada correctamente.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instalacion
      @instalacion = Instalacion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def instalacion_params
      params.expect(instalacion: [ :customer_name, :string, :adress, :string, :date, :date, :start_time, :time, :duration, :int, :tecnico_id ])
    end
end
