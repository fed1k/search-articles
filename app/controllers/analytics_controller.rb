class AnalyticsController < ApplicationController
  before_action :set_analytic, only: %i[ show edit update destroy ]

  # GET /analytics or /analytics.json
  def index
    ip = ipinfo()
    if ip 
      @analytic_trend = Analytic.where(ip: ip).group_by(&:searchQuery).map{|k,v| [k, v.count]}.sort_by{|k,v| v}.reverse
    end
  end

  def ipinfo
    
    access_token = 'd5d41ac8302a60'
    handler = IPinfo::create(access_token)
    details = handler.details()
    city = details.ip
    return city
  end

  # GET /searchQueryanalytics/1 or /analytics/1.json
  def show
  end

  # GET /analytics/new
  def new
    @analytic = Analytic.new
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
    ip = ipinfo()
    if ip
      @analytic = Analytic.new({ip: ip, searchQuery: params[:searchQuery]})
      @analytic.save
    end
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
