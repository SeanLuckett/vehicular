module Api::V1
  class OptionsController < ApiController
    def index
      json_response Option.all
    end

    def show
      option = Option.find params[:id]
      json_response option

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find option with that id'
    end

    def create
      option = Option.new option_params
      if option.save
        json_response option, :created
      else
        render json: option, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def update
      option = Option.find params[:id]
      if option.update(option_params)
        json_response option
      else
        render json: option, status: 422, serializer: ERROR_SERIALIZER
      end

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find option with that id'
    end

    def destroy
      option = Option.find params[:id]
      option.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find option with that id'
    end

    private

    def option_params
      params.require(:option).permit :name
    end
  end
end