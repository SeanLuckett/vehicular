require 'rails_helper'

RSpec.describe 'ModelOptions', type: :request do
  describe 'Add options to a model' do
    let(:model) { create :model }

    context 'option exists' do
      let(:option) { create :option }

      it 'adds the option to the model' do
        expect {
          post api_v1_model_add_option_path(model),
               params: { option_id: option.id }
        }.to change(model.options, :count).by(1)
      end

      it 'returns ok status' do
        post api_v1_model_add_option_path(model),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end

      it 'returns model with options' do
        post api_v1_model_add_option_path(model),
             params: { option_id: option.id }

        model_json = json(response.body)['data']
        rel_json = model_json['relationships']

        expect(model_json['type']).to eq 'models'
        expect(rel_json).to have_key 'options'
      end
    end

    context 'when an option does not exist' do
      let(:missing_id) { 404 }

      before do
        post api_v1_model_add_option_path(model),
             params: { option_id: missing_id }
      end

      it_behaves_like 'missing resource', Option do
        let!(:id) { missing_id }
      end
    end

    context 'when model already has option' do
      let(:option) { create :option }

      before do
        model.options << option
      end

      it 'does not change the options collection' do
        expect {
          post api_v1_model_add_option_path(model),
               params: { option_id: option.id }
        }.not_to change(model.options, :count)
      end

      it 'returns status ok' do
        post api_v1_model_add_option_path(model),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'Remove options from a model' do
    context 'option association exists' do
      let!(:model) { create :model_with_option }
      let(:option) { model.options.first }

      it 'removes the option from the model' do
        expect {
          post api_v1_model_remove_option_path(model),
               params: { option_id: option.id }
        }.to change(model.options, :count).by(-1)
      end

      it 'does not delete the option from the database' do
        expect {
          post api_v1_model_remove_option_path(model),
               params: { option_id: option.id }
        }.not_to change(Option, :count)
      end

      it 'returns ok status' do
        post api_v1_model_remove_option_path(model),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end

      it 'returns model with options' do
        post api_v1_model_remove_option_path(model),
             params: { option_id: option.id }

        model_json = json(response.body)['data']
        rel_json = model_json['relationships']

        expect(model_json['type']).to eq 'models'
        expect(rel_json).to have_key 'options'
      end
    end

    context 'option association missing' do
      let(:model) { create :model }
      let(:option) { create :option }

      it 'does not change the options collection' do
        expect {
          post api_v1_model_remove_option_path(model),
               params: { option_id: option.id }
        }.not_to change(model.options, :count)
      end

      it 'returns status ok' do
        post api_v1_model_remove_option_path(model),
             params: { option_id: option.id }

        expect(response).to have_http_status :ok
      end
    end
  end
end