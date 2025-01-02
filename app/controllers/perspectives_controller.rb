class PerspectivesController < ApplicationController
  before_action :set_perspective, only: %i[ show edit update destroy ]

  # GET /perspectives or /perspectives.json
  def index
    @perspectives = Perspective.all
  end

  # GET /perspectives/1 or /perspectives/1.json
  def show
    @results = begin
      # FIXME: replace this unsecure thing with the safe thing
      ApplicationRecord.connection.execute @perspective.query
    rescue => e
      [ error: e.message ]
    end
  end

  # GET /perspectives/new
  def new
    @perspective = Perspective.new
  end

  # GET /perspectives/1/edit
  def edit
  end

  # POST /perspectives or /perspectives.json
  def create
    @perspective = Perspective.new(perspective_params)

    respond_to do |format|
      if @perspective.save
        format.html { redirect_to @perspective, notice: "Perspective was successfully created." }
        format.json { render :show, status: :created, location: @perspective }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @perspective.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /perspectives/1 or /perspectives/1.json
  def update
    respond_to do |format|
      if @perspective.update(perspective_params)
        format.html { redirect_to @perspective, notice: "Perspective was successfully updated." }
        format.json { render :show, status: :ok, location: @perspective }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @perspective.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perspectives/1 or /perspectives/1.json
  def destroy
    @perspective.destroy!

    respond_to do |format|
      format.html { redirect_to perspectives_path, status: :see_other, notice: "Perspective was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_perspective
      @perspective = Perspective.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def perspective_params
      params.expect(perspective: [ :name, :query ])
    end
end
