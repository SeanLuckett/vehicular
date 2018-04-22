require 'rails_helper'

RSpec.describe 'ModelOptions', type: :request do
  after(:all) do
    Make.destroy_all
    Model.destroy_all
  end

  describe 'POST /models/:model_id/options' do
    let(:model) { create :model }

    it 'returns created status code' do
      post api_v1_model_options_path(model),
           params: { option: attributes_for(:option) }
      expect(response).to have_http_status '201'
    end

    it 'creates an option for the model' do
      expect {
        post api_v1_model_options_path(model),
             params: { option: attributes_for(:option) }
      }.to change(model.options, :count).by(1)
    end

    it 'returns created option' do
      option_params = attributes_for :option
      post api_v1_model_options_path(model), params: { option: option_params }

      option_json = json(response.body)['data']

      expect(option_json['type']).to eq 'options'
      expect(option_json['attributes']['name']).to eq option_params[:name]
    end

    it 'returns relationship to included model' do
      post api_v1_model_options_path(model),
           params: { option: attributes_for(:option) }

      model_json = json(response.body)['data']
      rel_json = model_json['relationships']['models']['data'].first

      expect(rel_json['id']).to eq model.id.to_s
    end

    context 'when making errors' do
      let(:invalid_option_attrs) { attributes_for(:option, name: nil) }

      before do
        post api_v1_model_options_path(model),
             params: { option: invalid_option_attrs }
      end

      it 'returns an error code' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper error response' do
        errors = json(response.body)['errors']
        error_on_name = errors.first

        expect(error_on_name['source']['pointer']).to eq '/data/attributes/name'
        expect(error_on_name['detail']).to eq "can't be blank"
      end
    end

    context 'when association exists' do
      let(:model) { create :model_with_option }
      let(:option) { model.options.first }

      before do
        post api_v1_model_options_path(model),
             params: { option: option.attributes }
      end

      it 'returns ?' do
        errors = json(response.body)['errors']
      end
    end

    xcontext 'when model not found' do
      before do
        allow(Model).to receive(:find) { raise ActiveRecord::RecordNotFound }

        model = create :model
        patch api_v1_make_model_path(model.make, model)
      end

      after { Model.destroy_all }

      it_behaves_like 'missing resource', Model
    end
  end

  describe 'PATCH /models/:model_id/options/:id' do
    xcontext 'when changing attribute' do
      let(:option) { create :option }
      let(:new_name) { 'Rocket Launcher' }

      before do
        patch api_v1_model_option_path(option.make, option),
              params: { option: { name: new_name } }
      end

      after(:all) { Model.destroy_all }

      xit 'returns correct status code' do
        expect(response).to have_http_status '200'
      end

      xit 'updates the model' do
        expect(model.reload.name).to eq new_name
      end

      xit 'returns the modified model as json' do
        model_json = json(response.body)['data']
        expect(model_json['attributes']['name']).to eq new_name
      end
    end

    xcontext 'when making an error' do
      xit 'returns status code' do
        model = create :model
        patch api_v1_make_model_path(model.make, model),
              params: { model: { name: nil } }
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    xcontext 'when model not found' do
      before do
        allow(Model).to receive(:find) { raise ActiveRecord::RecordNotFound }

        model = create :model
        patch api_v1_make_model_path(model.make, model)
      end

      after { Model.destroy_all }

      it_behaves_like 'missing resource', Model
    end
  end

  describe 'GET /models' do
    before do
      make = create :make
      2.times { create :model, make_id: make.id }
      get api_v1_make_models_path(make)
    end

    xit 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    xit 'gets list of models' do
      list_json = json(response.body)['data']
      expect(list_json.length).to eq Model.count
    end
  end

  describe 'GET /model/:id' do
    let(:model) { create :model }

    before { get api_v1_make_model_path(model.make, model) }

    after(:all) { Model.destroy_all }

    xit 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    xit 'returns the model' do
      model_json = json(response.body)['data']
      expect(model_json['id']).to eq model.id.to_s
    end

    xcontext 'when model not found' do
      before do
        model = create :model
        allow(Model).to receive(:find) { raise ActiveRecord::RecordNotFound }

        get api_v1_make_model_path(model.make, model)
      end

      after { Model.destroy_all }

      it_behaves_like 'missing resource', Model
    end
  end

  describe 'DELETE /model/:id' do
    let!(:deletable) { create :model }

    xit 'returns no content status' do
      delete api_v1_make_model_path(deletable.make, deletable)
      expect(response).to have_http_status :no_content
    end

    xit 'only deletes model' do
      expect {
        delete api_v1_make_model_path(deletable.make, deletable)
      }.to change(Model, :count).by(-1)
    end

    xcontext 'when model not found' do
      before do
        allow(Model).to receive(:find) { raise ActiveRecord::RecordNotFound }

        delete api_v1_make_model_path(deletable.make, deletable)
      end

      after { Model.destroy_all }

      it_behaves_like 'missing resource', Model
    end
  end
end
