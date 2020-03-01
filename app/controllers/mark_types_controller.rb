class MarkTypesController < ApplicationController
  before_action :set_mark_type, only: [:show, :edit, :update, :destroy]

  # GET /mark_types
  # GET /mark_types.json
  def index
    @mark_types = MarkType.all
  end

  # GET /mark_types/1
  # GET /mark_types/1.json
  def show
  end

  # GET /mark_types/new
  def new
    @mark_type = MarkType.new
  end

  # GET /mark_types/1/edit
  def edit
  end

  # POST /mark_types
  # POST /mark_types.json
  def create
    @mark_type = MarkType.new(mark_type_params)

    respond_to do |format|
      if @mark_type.save
        format.html { redirect_to @mark_type, notice: 'Mark type was successfully created.' }
        format.json { render :show, status: :created, location: @mark_type }
      else
        format.html { render :new }
        format.json { render json: @mark_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mark_types/1
  # PATCH/PUT /mark_types/1.json
  def update
    respond_to do |format|
      if @mark_type.update(mark_type_params)
        format.html { redirect_to @mark_type, notice: 'Mark type was successfully updated.' }
        format.json { render :show, status: :ok, location: @mark_type }
      else
        format.html { render :edit }
        format.json { render json: @mark_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mark_types/1
  # DELETE /mark_types/1.json
  def destroy
    @mark_type.destroy
    respond_to do |format|
      format.html { redirect_to mark_types_url, notice: 'Mark type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mark_type
      @mark_type = MarkType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mark_type_params
      params.require(:mark_type).permit(:name)
    end
end
