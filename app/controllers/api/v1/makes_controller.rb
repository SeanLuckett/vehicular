module Api::V1
  class MakesController < ApiController
    def create
      make = Make.new make_params
      if make.save
        render json: make, status: :created
      end
    end

    private

    def make_params
      params.require(:make).permit :name
    end

  end

end
