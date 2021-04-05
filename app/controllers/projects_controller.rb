class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy checkout]
  before_action :authenticate_user!, except: [:index, :show]


  # GET /projects or /projects.json
  def index
    @projects = Project.active
  end

  # GET /projects/1 or /projects/1.json
  def show
    @client_token = Braintree::ClientToken.generate
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        ExpireProjectJob.set(wait_until: @project.expires_at).perform_later(@project)
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def checkout
    if @project
      nonce = params[:payment_method_nonce]

      result = Braintree::Transaction.sale(
        amount: @project.donation_goal,
        payment_method_nonce: nonce
      )

      if result
        redirect_to project_path, notice: "Success!"
      else
        # 錯誤處理
      end
    else
      # 錯誤處理
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :donation_goal, :user_id, :description, :thumbnail)
    end
end
