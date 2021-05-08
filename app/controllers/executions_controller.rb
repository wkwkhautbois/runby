class ExecutionsController < ApplicationController
  before_action :check_login
  before_action :set_execution, only: [ :show ]

  # GET /executions or /executions.json
  def index
    @executions = Execution.all
  end

  # GET /executions/1 or /executions/1.json
  def show
  end

  # GET /executions/new
  def new
    @execution = Execution.new
  end

  # POST /executions or /executions.json
  def create
    @execution = Execution.new(execution_params)

    respond_to do |format|
      if @execution.save
        format.html { redirect_to @execution, notice: "Execution was successfully created." }
        format.json { render :show, status: :created, location: @execution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @execution.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_execution
      @execution = Execution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def execution_params
      params.require(:execution)
            .permit(:account_id, :program, :input)
            .merge(account_id: current_account.id)
    end
end
