class StatementsController < ApplicationController
  before_action :set_statement, only: %i[ show edit update destroy ]

  # GET /statements or /statements.json
  def index
    @statements = Statement.all
  end

  # GET /statements/1 or /statements/1.json
  def show
  end

  # GET /statements/new
  def new
    @statement = Statement.new(
      statement_format: StatementFormat.first
    )
  end

  # GET /statements/1/edit
  def edit
  end

  def create
    @statement = Statement.import_from_file(statement_from_file_params)

    redirect_to statement_url(@statement), notice: "Statement was successfully created."
  end

  # POST /statements or /statements.json
  def create_og
    @statement = Statement.new(statement_params)

    respond_to do |format|
      if @statement.save
        format.html { redirect_to statement_url(@statement), notice: "Statement was successfully created." }
        format.json { render :show, status: :created, location: @statement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statements/1 or /statements/1.json
  def update
    respond_to do |format|
      if @statement.update(statement_params)
        format.html { redirect_to statement_url(@statement), notice: "Statement was successfully updated." }
        format.json { render :show, status: :ok, location: @statement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statements/1 or /statements/1.json
  def destroy
    @statement.destroy!

    respond_to do |format|
      format.html { redirect_to statements_url, notice: "Statement was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_statement
    @statement = Statement.find(params[:id])
  end

  def statement_from_file_params
    params.require(:statement).permit(:file, :statement_format_id)
  end

  # Only allow a list of trusted parameters through.
  def statement_params
    params.require(:statement).permit(:filename, :statement_format_id)
  end
end
