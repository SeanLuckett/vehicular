require 'rails_helper'

RSpec.describe VehicleOptionHandler, type: :model do
  describe '#add_option' do
    let(:model) { create :model_with_options }
    let(:vehicle) { create :vehicle, model_id: model.id }

    context 'option is available through model' do
      let(:option_id) { model.options.last.id.to_s }
      let(:option_handler) { VehicleOptionHandler.new(vehicle, option_id) }

      it 'adds the option to the vehicle' do
        expect {
          option_handler.add_option!
        }.to change(vehicle.options, :count).by(1)
      end

      it 'returns vehicle' do
        expect(option_handler.add_option!.id).to eq vehicle.id
      end
    end

    context 'when an option is not available through model' do
      let(:wrong_option_id) { '404' }
      let(:option_handler) { VehicleOptionHandler.new(vehicle, wrong_option_id) }

      it 'does not add option to vehicle' do
        expect {
          option_handler.add_option!
        }.not_to change(vehicle.options, :count)
      end

      it 'returns false' do
        expect(option_handler.add_option!).to be false
      end
    end

    context 'when vehicle already has option' do
      let(:option) { model.options.first }

      before do
        vehicle.options << option
        @option_handler = VehicleOptionHandler.new(vehicle, option.id)
      end

      it 'does not change the options collection' do
        expect {
          @option_handler.add_option!
        }.not_to change(model.options, :count)
      end

      it 'returns vehicle unaltered' do
        expect(@option_handler.add_option!).to eq vehicle
      end
    end
  end

  describe '#remove_option' do
    let(:model) { create :model_with_options }
    let(:vehicle) { create :vehicle, id: 9, model_id: model.id }
    let(:option) { model.options.last }

    context 'vehicle has option' do
      before { vehicle.options << option }

      it 'removes the option from the vehicle' do
        option_handler = VehicleOptionHandler.new(vehicle, option.id.to_s)
        expect {
          option_handler.remove_option!
        }.to change(vehicle.options, :count).by(-1)
      end

      it 'does not delete the option from the database' do
        option_handler = VehicleOptionHandler.new(vehicle, option.id.to_s)
        expect {
          option_handler.remove_option!
        }.not_to change(Option, :count)
      end
    end

    context 'when vehicle does not have option' do
      let(:option_handler) { VehicleOptionHandler.new(vehicle, '1') }

      it 'returns the vehicle' do
        expect(option_handler.remove_option!.id).to eq vehicle.id
      end

      it 'does not change the options collection' do
        expect {
          option_handler.remove_option!
        }.not_to change(vehicle.options, :count)
      end
    end
  end
end
