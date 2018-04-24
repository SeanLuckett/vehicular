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
      option_handler = VehicleOptionHandler.new(vehicle, params[:option_id])

      if option_handler.add_option!
        json_response vehicle
      else
        vehicle
          .errors
          .add(:model_options, 'Option unavailable on that make and model')

        error_json vehicle
      end
    end

    def remove_option
      vehicle = Vehicle.find params[:vehicle_id]
      option_handler = VehicleOptionHandler.new(vehicle, params[:option_id])

      option_handler.remove_option!
      json_response vehicle
    end

    private

    def vehicle_params
      params.require(:vehicle).permit :owner, :model_id
    end
  end
end