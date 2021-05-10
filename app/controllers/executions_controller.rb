class ExecutionsController < ApplicationController
  before_action :check_login
  before_action :set_execution, only: [ :show ]

  # GET /executions
  def index
    @executions = Execution.all.order(created_at: :desc)
  end

  # GET /executions/1
  def show
  end

  # GET /executions/new
  def new
    @execution = Execution.new
  end

  # POST /executions
  def create
    @execution = Execution.new(execution_params)

    if @execution.save
      flash[:info] = "実行しました"
      redirect_to @execution
    else
      render :new, status: :unprocessable_entity
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
