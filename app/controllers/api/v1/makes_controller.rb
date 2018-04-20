module Api::V1
  class MakesController < ApiController
    ERROR_SERIALIZER = ActiveModel::Serializer::ErrorSerializer

    def index
      render json: Make.all, status: :ok
    end

    def show
      make = Make.find params[:id]
      render json: make, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json
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
      render_error_json
    end

    def destroy
      make = Make.find params[:id]
      make.destroy

    rescue ActiveRecord::RecordNotFound
      render_error_json
    end

    private

    def render_error_json
      missing_resource = Make.new
      missing_resource.errors.add(:not_found, "Could not find #{Make.name.downcase} with that id")
      render json: missing_resource,
             status: :not_found, serializer: ERROR_SERIALIZER
    end

    def make_params
      params.require(:make).permit :name
    end

  end

end
