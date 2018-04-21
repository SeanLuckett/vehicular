module Api::V1
  class MakesController < ApiController
    def index
      render json: Make.all, status: :ok
    end

    def show
      make = Make.find params[:id]
      render json: make, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json Make
    end

    def create
      make = Make.new make_params
      if make.save
        render json: make, status: :created
      else
        render json: make, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def update
      make = Make.find params[:id]
      if make.update(make_params)
        render json: make, status: :ok
      else
        render json: make, status: 422, serializer: ERROR_SERIALIZER
      end

    rescue ActiveRecord::RecordNotFound
      render_error_json Make
    end

    def destroy
      make = Make.find params[:id]
      make.destroy

    rescue ActiveRecord::RecordNotFound
      render_error_json Make
    end

    private

    def make_params
      params.require(:make).permit :name
    end

  end

end
