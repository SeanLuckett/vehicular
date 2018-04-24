module Api::V1
  class ModelsController < ApiController
    def index
      make = Make.find(params[:make_id])
      json_response make.models
    end

    def show
      model = Model.find params[:id]
      json_response model
    end

    def create
      make = Make.find(params[:make_id])
      model = make.models.build model_params

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

      unless model.options.exists? params[:option_id]
        model.options << Option.find(params[:option_id])
      end

      json_response model
    end

    def remove_option
      model = Model.find params[:model_id]

      if model.options.exists? params[:option_id]
        model.options.destroy params[:option_id]
      end

      json_response model
    end

    private

    def model_params
      params.require(:model).permit :name, :year
    end
  end

end