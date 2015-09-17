class ProvidersController < ApplicationController

  def index
    @providers = Provider.all_alphabetical.search(sanitized_search).page(params[:page])
    respond_to do |format|
      format.html {@providers}
      format.json { render json: @providers}
    end
  end
end
