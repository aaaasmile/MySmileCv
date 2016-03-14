class LuzsController < ApplicationController
  before_action :set_luz, only: [:show, :edit, :update, :destroy]

  # GET /luzs
  # GET /luzs.json
  def index
    @luzs = Luz.all
  end

  # GET /luzs/1
  # GET /luzs/1.json
  def show
  end

  # GET /luzs/new
  def new
    @luz = Luz.new
  end

  # GET /luzs/1/edit
  def edit
  end

  # POST /luzs
  # POST /luzs.json
  def create
    @luz = Luz.new(luz_params)

    respond_to do |format|
      if @luz.save
        format.html { redirect_to @luz, notice: 'Luz was successfully created.' }
        format.json { render :show, status: :created, location: @luz }
      else
        format.html { render :new }
        format.json { render json: @luz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /luzs/1
  # PATCH/PUT /luzs/1.json
  def update
    respond_to do |format|
      if @luz.update(luz_params)
        format.html { redirect_to @luz, notice: 'Luz was successfully updated.' }
        format.json { render :show, status: :ok, location: @luz }
      else
        format.html { render :edit }
        format.json { render json: @luz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /luzs/1
  # DELETE /luzs/1.json
  def destroy
    @luz.destroy
    respond_to do |format|
      format.html { redirect_to luzs_url, notice: 'Luz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_luz
      @luz = Luz.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def luz_params
      params.fetch(:luz, {})
    end
end
