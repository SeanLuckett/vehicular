require 'rails_helper'

RSpec.describe 'VehicleOptions', type: :request do
  describe 'Add model options to vehicle' do
    let(:model) { create :model_with_options }
    let(:vehicle) { create :vehicle, model_id: model.id }

    context 'option is available through model' do
      let(:option) { model.options.last }

      it 'adds the option to the vehicle' do
        expect {
          post api_v1_vehicle_add_option_path(vehicle),
               params: { option_id: option.id }
        }.to change(vehicle.options, :count).by(1)
      end

      it 'returns ok status' do
        post api_v1_vehicle_add_option_path(vehicle),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end

      it 'returns vehicle with options' do
        post api_v1_vehicle_add_option_path(vehicle),
             params: { option_id: option.id }

        vehicle_json = json(response.body)['data']
        rel_json = vehicle_json['relationships']

        expect(vehicle_json['type']).to eq 'vehicles'
        expect(rel_json).to have_key 'options'
      end
    end

    context 'when an option is not available through model' do
      let(:wrong_option) { create :option }

      it 'does not add option to vehicle' do
        expect {
          post api_v1_vehicle_add_option_path(vehicle),
               params: { option_id: wrong_option.id }
        }.not_to change(vehicle.options, :count)
      end

      it 'gives an unprocessable entity response status' do
        post api_v1_vehicle_add_option_path(vehicle),
             params: { option_id: wrong_option.id }
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns helpful error message' do
        post api_v1_vehicle_add_option_path(vehicle),
             params: { option_id: wrong_option.id }

        error_json = json(response.body)['errors']
        expect(error_json.first['detail'])
          .to eq 'Option unavailable on that make and model'
      end
    end

    context 'when vehicle already has option' do
      let(:existing_option) { model.options.first}

      before do
        vehicle.options << existing_option
      end

      it 'does not change the options collection' do
        expect {
          post api_v1_vehicle_add_option_path(vehicle),
               params: { option_id: existing_option.id }
        }.not_to change(model.options, :count)
      end

      it 'returns status ok' do
        post api_v1_vehicle_add_option_path(vehicle),
             params: { option_id: existing_option.id }

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'Remove model options from vehicle' do
    context 'vehicle has option' do
      let!(:vehicle) { create :vehicle_with_option }
      let(:option) { vehicle.options.first }

      it 'removes the option from the vehicle' do
        expect {
          post api_v1_vehicle_remove_option_path(vehicle),
               params: { option_id: option.id }
        }.to change(vehicle.options, :count).by(-1)
      end

      it 'does not delete the option from the database' do
        expect {
          post api_v1_vehicle_remove_option_path(vehicle),
               params: { option_id: option.id }
        }.not_to change(Option, :count)
      end

      it 'returns ok status' do
        post api_v1_vehicle_remove_option_path(vehicle),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end

      it 'returns vehicle with options' do
        post api_v1_vehicle_remove_option_path(vehicle),
             params: { option_id: option.id }

        vehicle_json = json(response.body)['data']
        rel_json = vehicle_json['relationships']

        expect(vehicle_json['type']).to eq 'vehicles'
        expect(rel_json).to have_key 'options'
      end
    end

    context 'when vehicle does not have option' do
      let(:vehicle) { create :vehicle }
      let(:option) { create :option }

      it 'does not change the options collection' do
        expect {
          post api_v1_vehicle_remove_option_path(vehicle),
               params: { option_id: option.id }
        }.not_to change(vehicle.options, :count)
      end

      it 'returns status ok' do
        post api_v1_vehicle_remove_option_path(vehicle),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end
    end
  end
end
