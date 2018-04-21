module Api::V1
  class ModelsController < ApiController
    def index
      render json: Model.all, status: :ok
    end

    def show
      model = Model.find params[:id]
      render json: model, status: :ok

    rescue ActiveRecord::RecordNotFound
      render_error_json Model
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
      render_error_json Model
    end

    def destroy
      model = Model.find params[:id]
      model.destroy

    rescue ActiveRecord::RecordNotFound
      render_error_json Model
    end

    private

    def model_params
      params.require(:model).permit :name, :year
    end
  end

end