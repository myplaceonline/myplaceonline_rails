class ApiController < MyplaceonlineController
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: categoriesForCurrentUser(nil)}
    end
  end
end
