module Api::V1
  class ModelsController < ApiController
    def index
      json_response Model.all
    end

    def show
      model = Model.find params[:id]
      json_response model
    end

    def create
      model = Make.find(params[:make_id])
      model = model.models.build model_params

      if model.save
        json_response model, :created
      else
        render json: model, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def update
      model = Model.find params[:id]

      if model.update(model_params)
        json_response model
      else
        render json: model, status: 422, serializer: ERROR_SERIALIZER
      end
    end

    def destroy
      model = Model.find params[:id]
      model.destroy
    end

    def add_option
      model = Model.find params[:model_id]
      option = Option.find params[:option_id]

      option_ids = model.option_ids
      new_ids = option_ids << option.id
      model.option_ids = new_ids.uniq

      json_response model
    end

    def remove_option
      model = Model.find params[:model_id]
      option = Option.find params[:option_id]

      option_ids = model.option_ids
      new_option_ids = option_ids.reject { |id| id == option.id }

      model.option_ids = new_option_ids
      json_response model
    end

    private

    def model_params
      params.require(:model).permit :name, :year
    end
  end

end