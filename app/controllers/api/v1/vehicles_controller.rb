module Api::V1
  class VehiclesController < ApiController
    def index
      model = Model.find(params[:model_id])
      json_response model.vehicles
    end

    def show
      vehicle = Vehicle.find params[:id]
      json_response vehicle
    end

    def create
      model = Model.find(params[:model_id])
      vehicle = model.vehicles.build vehicle_params

      if vehicle.save
        json_response vehicle, :created, ['model.make']
      end
    end

    def update
      vehicle = Vehicle.find params[:id]

      if vehicle.update(vehicle_params)
        json_response vehicle
      end
    end

    def destroy
      vehicle = Vehicle.find params[:id]
      vehicle.destroy
    end

    def add_option
      vehicle = Vehicle.find params[:vehicle_id]
      option_id = params[:option_id]

      if vehicle.model.options.exists? option_id

        if !vehicle.options.exists? option_id
          vehicle.options << Option.find(option_id)
        end

        json_response vehicle
      else
        render_error_json 'Option unvailable on that make and model',
                          :unprocessable_entity
      end
    end

    def remove_option
      vehicle = Vehicle.find params[:vehicle_id]

      if vehicle.options.exists? params[:option_id]
        vehicle.options.destroy params[:option_id]
      end

      json_response vehicle
    end

    private

    def vehicle_params
      params.require(:vehicle).permit :owner, :model_id
    end
  end
end