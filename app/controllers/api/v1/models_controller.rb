module Api::V1
  class ModelsController < ApiController
    def index
      render json: Model.all, status: :ok
    end

    def show
      model = Model.find params[:id]
      render json: model, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find model with that id'
    end

    def create
      model = Make.find(params[:make_id])
      model = model.models.build model_params

      if model.save
        render json: model, status: :created
      else
        render json: model, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def update
      model = Model.find params[:id]

      if model.update(model_params)
        render json: model, status: :ok
      else
        render json: model, status: 422, serializer: ERROR_SERIALIZER
      end

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find model with that id'
    end

    def destroy
      model = Model.find params[:id]
      model.destroy

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find model with that id'
    end

    def add_option
      model = Model.find params[:model_id]
      option = Option.find params[:option_id]

      model.options << option

      render json: model, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find option with that id'

    rescue ActiveRecord::RecordInvalid
      render_error_json :unprocessable_entity,
                        "Model with id: #{model.id} already has this option."
    end

    def remove_option
      model = Model.find params[:model_id]
      option = Option.find params[:option_id]

      option_ids = model.option_ids
      new_option_ids = option_ids.reject { |id| id == option.id }

      model.option_ids = new_option_ids
      render json: model, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json :not_found, 'Could not find option with that id'
    end

    private

    def model_params
      params.require(:model).permit :name, :year
    end
  end

end