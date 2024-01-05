class AnalyticsController < ApplicationController
  before_action :set_analytic, only: %i[ show edit update destroy ]

  # GET /analytics or /analytics.json
  def index
    @analytic_trend = Analytic.where(ip: request.ip).group_by(&:searchQuery).map{|k,v| [k, v.count]}.sort_by{|k,v| v}.reverse
  end

  # GET /searchQueryanalytics/1 or /analytics/1.json
  def show
  end

  # GET /analytics/new
  def new
    @analytic = Analytic.new
    @ip = request.ip
  end

  # GET /analytics/1/edit
  def edit
  end

  # POST /analytics or /analytics.json
  def create
    @analytic = Analytic.new(analytic_params)

    respond_to do |format|
      if @analytic.save
        format.html { redirect_to analytic_url(@analytic), notice: "Analytic was successfully created." }
        format.json { render :show, status: :created, location: @analytic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @analytic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /analytics/1 or /analytics/1.json
  def update
    respond_to do |format|
      if @analytic.update(analytic_params)
        format.html { redirect_to analytic_url(@analytic), notice: "Analytic was successfully updated." }
        format.json { render :show, status: :ok, location: @analytic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @analytic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /analytics/1 or /analytics/1.json
  def destroy
    @analytic.destroy!

    respond_to do |format|
      format.html { redirect_to analytics_url, notice: "Analytic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def save_log
    @analytic = Analytic.new({ip: request.ip, searchQuery: params[:searchQuery]})
    @analytic.save
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_analytic
      @analytic = Analytic.find(params[:id])
    end

    

    # Only allow a list of trusted parameters through.
    def analytic_params
      params.require(:analytic).permit(:ip, :searchQuery)
    end
end
