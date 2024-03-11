class StatementFormatsController < ApplicationController
  before_action :set_statement_format, only: %i[ show edit update destroy ]

  # GET /statement_formats or /statement_formats.json
  def index
    @statement_formats = StatementFormat.all
  end

  # GET /statement_formats/1 or /statement_formats/1.json
  def show
  end

  # GET /statement_formats/new
  def new
    @statement_format = StatementFormat.new
  end

  # GET /statement_formats/1/edit
  def edit
  end

  # POST /statement_formats or /statement_formats.json
  def create
    @statement_format = StatementFormat.new(statement_format_params)

    respond_to do |format|
      if @statement_format.save
        format.html { redirect_to statement_format_url(@statement_format), notice: "Statement format was successfully created." }
        format.json { render :show, status: :created, location: @statement_format }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @statement_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statement_formats/1 or /statement_formats/1.json
  def update
    respond_to do |format|
      if @statement_format.update(statement_format_params)
        format.html { redirect_to statement_format_url(@statement_format), notice: "Statement format was successfully updated." }
        format.json { render :show, status: :ok, location: @statement_format }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @statement_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statement_formats/1 or /statement_formats/1.json
  def destroy
    @statement_format.destroy!

    respond_to do |format|
      format.html { redirect_to statement_formats_url, notice: "Statement format was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement_format
      @statement_format = StatementFormat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def statement_format_params
      params.require(:statement_format).permit(:label, :date_fmt, :date_col, :amount_col, :currency_col, :party_col, :payor_col,
                                               :payee_col, :description_col, :default_currency_col)
    end
end
