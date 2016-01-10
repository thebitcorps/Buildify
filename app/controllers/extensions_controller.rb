class ExtensionsController < ApplicationController
  before_action :set_extension, only: [ :edit, :update, :destroy]

  def index
    @extensions = Extension.where_construction params[:construction_id]
    @construction = Construction.find params[:construction_id]
  end


  def new
    @extension = Extension.new
  end

  def edit
  end

  def create
    @extension = Extension.new(extension_params)

    respond_to do |format|
      if @extension.save
        format.html { redirect_to extensions_path(construction_id: @extension.construction_id), notice: 'Extension was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @extension.update(extension_params)
        format.html { redirect_to extensions_path(construction_id: @extension.construction_id), notice: 'Extension was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  def destroy
    @extension.destroy
    respond_to do |format|
      format.html { redirect_to extensions_url, notice: 'Extension was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extension
      @extension = Extension.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extension_params
      params.require(:extension).permit(:date, :construction_id, :amount)
    end
end
