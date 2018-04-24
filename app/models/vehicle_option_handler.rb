class VehicleOptionHandler
  def initialize(vehicle, option_id)
    @vehicle = vehicle
    @option_id = option_id
  end

  def add_option!
    return vehicle if vehicle_has_option?

    if vehicle.model.options.exists? option_id
      vehicle.options << Option.find(option_id)
      vehicle
    else
      false
    end
  end

  def remove_option!
    return vehicle unless vehicle_has_option?
    vehicle.options.destroy option_id
  end

  private

  def vehicle_has_option?
    vehicle.options.exists? option_id
  end

  attr_accessor :vehicle, :option_id
end