class StatementsController < ApplicationController
  before_action :set_statement, only: %i[ show edit update destroy ]

  # GET /statements or /statements.json
  def index
    @statements = Statement.for_views
  end

  # GET /statements/1 or /statements/1.json
  def show
  end

  # GET /statements/new
  def new
    @statement = Statement.new
  end

  # GET /statements/1/edit
  def edit
  end

  def create
    statements = Statement.transaction do
      create_from_files_params[:files].map do |file|
        Statement.import_from_file(create_from_files_params.except(:files).merge(file: file))
      end
    end

    redirect_to statement_url(statements.first), notice: "#{statements.count} statement(s) successfully created."
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
      format.html { redirect_to statements_url, notice: "Statement '#{@statement.filename}' was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_statement
    @statement = Statement.for_views.find(params[:id])
  end

  def create_from_files_params
    params.require(:statement).permit(:statement_format_id, files: [])
  end

  # Only allow a list of trusted parameters through.
  def statement_params
    params.require(:statement).permit(:filename, :statement_format_id)
  end
end
