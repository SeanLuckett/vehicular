require 'rails_helper'

RSpec.describe 'Models', type: :request do
  describe 'POST /makes/:make_id/models' do
    let(:make) { create :make }

    it 'returns created status code' do
      post api_v1_make_models_path(make),
           params: { model: attributes_for(:model) }
      expect(response).to have_http_status '201'
    end

    it 'creates a model' do
      expect {
        post api_v1_make_models_path(make),
             params: { model: attributes_for(:model) }
      }.to change(Model, :count).by(1)
    end

    it 'returns created model as json' do
      model_params = attributes_for :model
      post api_v1_make_models_path(make), params: { model: model_params }

      model_json = json(response.body)['data']
      expect(model_json['type']).to eq 'models'
      expect(model_json['attributes']['name']).to eq model_params[:name]
      expect(model_json['attributes']['year']).to eq model_params[:year]
    end

    it 'returns the make relationship' do
      post api_v1_make_models_path(make),
           params: { model: attributes_for(:model) }

      model_json = json(response.body)['data']
      rel_json = model_json['relationships']['make']['data']

      expect(rel_json['id']).to eq make.id.to_s
    end

    context 'when making errors' do
      let(:invalid_model_attrs) { attributes_for(:model, name: nil, year: 'blah') }

      before do
        post api_v1_make_models_path(make), params: { model: invalid_model_attrs }
      end

      it 'returns an error code' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper error response' do
        errors = json(response.body)['errors']
        error_on_name = errors.first
        error_on_year = errors.last

        expect(error_on_name['source']['pointer']).to eq '/data/attributes/name'
        expect(error_on_name['detail']).to eq "can't be blank"

        expect(error_on_year['source']['pointer']).to eq '/data/attributes/year'
        expect(error_on_year['detail']).to eq 'is not a number'
      end
    end
  end

  describe 'PATCH /makes/make_id/models/:id' do
    context 'when changing attribute' do
      let(:model) { create :model }
      let(:new_name) { 'Prius' }

      before do
        patch api_v1_make_model_path(model.make, model),
              params: { model: { name: new_name } }
      end

      it 'returns correct status code' do
        expect(response).to have_http_status '200'
      end

      it 'updates the model' do
        expect(model.reload.name).to eq new_name
      end

      it 'returns the modified model as json' do
        model_json = json(response.body)['data']
        expect(model_json['attributes']['name']).to eq new_name
      end
    end

    context 'when making an error' do
      it 'returns status code' do
        model = create :model
        patch api_v1_make_model_path(model.make, model),
              params: { model: { name: nil } }
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when model not found' do
      let(:missing_id) { 404 }

      before do
        make = create :make
        patch api_v1_make_model_path(make, missing_id)
      end

      it_behaves_like 'missing resource', Model do
        let(:id) { missing_id }
      end
    end
  end

  describe 'GET /makes/:make_id/models' do
    before do
      make = create :make
      2.times { create :model, make_id: make.id }
      get api_v1_make_models_path(make)
    end

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'gets list of models' do
      list_json = json(response.body)['data']
      expect(list_json.length).to eq Model.count
    end
  end

  describe 'GET /makes/:make_id/model/:id' do
    let(:model) { create :model }

    before { get api_v1_make_model_path(model.make, model) }

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'returns the model' do
      model_json = json(response.body)['data']
      expect(model_json['id']).to eq model.id.to_s
    end

    context 'when model not found' do
      let(:missing_id) { 404 }

      before do
        make = create :make
        get api_v1_make_model_path(make, missing_id)
      end

      it_behaves_like 'missing resource', Model do
        let(:id) { missing_id }
      end
    end
  end

  describe 'DELETE /makes/:make_id/model/:id' do
    let!(:deletable) { create :model }

    it 'returns no content status' do
      delete api_v1_make_model_path(deletable.make, deletable)
      expect(response).to have_http_status :no_content
    end

    it 'only deletes model' do
      expect {
        delete api_v1_make_model_path(deletable.make, deletable)
      }.to change(Model, :count).by(-1)
    end

    context 'when model not found' do
      let(:missing_id) { 404 }

      before do
        make = create :make

        delete api_v1_make_model_path(make, missing_id)
      end

      it_behaves_like 'missing resource', Model do
        let(:id) { missing_id }
      end
    end
  end
end
