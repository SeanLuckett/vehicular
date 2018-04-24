require 'rails_helper'

RSpec.describe 'vehicles', type: :request do
  describe 'POST /model/:model_id/vehicles' do
    let(:model) { create :model }

    it 'returns created status code' do
      post api_v1_model_vehicles_path(model),
           params: { vehicle: attributes_for(:vehicle) }
      expect(response).to have_http_status '201'
    end

    it 'creates a vehicle' do
      expect {
        post api_v1_model_vehicles_path(model),
             params: { vehicle: attributes_for(:vehicle) }
      }.to change(Vehicle, :count).by(1)
    end

    describe 'json response' do
      let(:vehicle_params) { attributes_for :vehicle, owner: 'Sally Serious' }

      before do
        post api_v1_model_vehicles_path(model),
             params: { vehicle: vehicle_params }
      end

      it 'returns created vehicle' do
        vehicle_json = json(response.body)['data']

        expect(vehicle_json['type']).to eq 'vehicles'
        expect(vehicle_json['attributes']['owner']).to eq vehicle_params[:owner]
      end

      it 'returns the model' do
        model_json = json(response.body)['data']['relationships']['model']
        expect(model_json['data']['id'].to_i).to eq model.id
      end

      it 'returns the make' do
        model_json = json(response.body)['included']
                       .first['relationships']['make']
        expect(model_json['data']['id'].to_i).to eq model.make.id
      end
    end
  end

  describe 'PATCH /vehicles/:id' do
    context 'when changing attribute' do
      let(:vehicle) { create :vehicle, owner: 'Serious Sam' }
      let(:new_owner) { 'Sally Serious' }

      before do
        patch api_v1_vehicle_path(vehicle),
              params: { vehicle: { owner: new_owner } }
      end

      it 'returns correct status code' do
        expect(response).to have_http_status '200'
      end

      it 'updates the vehicle' do
        expect(vehicle.reload.owner).to eq new_owner
      end

      it 'returns the modified vehicle as json' do
        vehicle_json = json(response.body)['data']
        expect(vehicle_json['attributes']['owner']).to eq new_owner
      end
    end

    context 'when changing associated model' do
      let(:vehicle) { create :vehicle }
      let(:different_model) { create :model }

      before do
        patch api_v1_vehicle_path(vehicle),
              params: {
                vehicle: { owner: 'Sam', model_id: different_model.id }
              }
      end

      it 'updates the vehicle model association' do
        expect(vehicle.reload.model).to eq different_model
      end
    end

    context 'when vehicle not found' do
      let(:missing_id) { 404 }

      before do
        patch api_v1_vehicle_path(missing_id)
      end

      it_behaves_like 'missing resource', Vehicle do
        let(:id) { missing_id }
      end
    end
  end

  describe 'GET /models/:model_id/vehicles' do
    let(:model) { create :model }

    before do
      create :vehicle
      2.times { create :vehicle, model_id: model.id }
      get api_v1_model_vehicles_path(model)
    end

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'gets list of vehicles' do
      list_json = json(response.body)['data']
      expect(list_json.length).to eq model.vehicles.count
    end
  end

  describe 'GET /vehicles/:id' do
    let(:vehicle) { create :vehicle }

    before { get api_v1_vehicle_path(vehicle) }

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'returns the vehicle' do
      vehicle_json = json(response.body)['data']
      expect(vehicle_json['id']).to eq vehicle.id.to_s
    end

    context 'when vehicle not found' do
      let(:missing_id) { 404 }

      before do
        get api_v1_vehicle_path(missing_id)
      end

      it_behaves_like 'missing resource', Vehicle do
        let(:id) { missing_id }
      end
    end
  end

  describe 'DELETE /makes/:make_id/vehicle/:id' do
    let!(:deletable) { create :vehicle }

    it 'returns no content status' do
      delete api_v1_vehicle_path(deletable)
      expect(response).to have_http_status :no_content
    end

    it 'only deletes vehicle' do
      expect {
        delete api_v1_vehicle_path(deletable)
      }.to change(Vehicle, :count).by(-1)
    end

    context 'when vehicle not found' do
      let(:missing_id) { 404 }

      before do
        delete api_v1_vehicle_path(missing_id)
      end

      it_behaves_like 'missing resource', Vehicle do
        let(:id) { missing_id }
      end
    end
  end
end
