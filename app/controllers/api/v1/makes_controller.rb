module Api::V1
  class MakesController < ApiController
    def index
      json_response Make.all
    end

    def show
      make = Make.find params[:id]
      json_response make
    end

    def create
      make = Make.new make_params
      if make.save
        json_response make, :created
      else
        error_json make
      end
    end

    def update
      make = Make.find params[:id]
      if make.update(make_params)
        json_response make
      else
        error_json make
      end

    end

    def destroy
      make = Make.find params[:id]
      make.destroy
      head :no_content
    end

    private

    def make_params
      params.require(:make).permit :name
    end

  end

end
