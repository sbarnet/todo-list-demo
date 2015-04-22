class TasksController < ApplicationController
  before_action :user_logged_in, except: [:index, :show]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :owns_task, only: [:update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = current_user.Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def owns_task
     if @task.user_id != current_user.id
        flash[:danger] = 'You are not authorized to do this'
        redirect_to root_url
      end
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      if params[:user_id]
        @task = current_user.task.find(params[:id])
      else
        @task = Task.find(params[:id])
      end
    end

   
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :due_date, :category_id)
    end
end
