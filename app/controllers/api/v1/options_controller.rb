module Api::V1
  class OptionsController < ApiController
    def create
      option = Option.new options_params
      if option.save
        render json: option, status: :created
      else
        render json: option, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def update
      option = Option.find params[:id]
      if option.update(option_params)
        render json: option, status: :ok
      else
        render json: option, status: 422, serializer: ERROR_SERIALIZER
      end

    rescue ActiveRecord::RecordNotFound
      render_error_json Option
    end

    private

    def option_params
      params.require(:option).permit :name
    end
  end
end