require 'rails_helper'

RSpec.describe 'Add options to a model', type: :request do
  after(:all) do
    Make.destroy_all
    Model.destroy_all
    Option.destroy_all
  end

  let(:model) { create :model }

  context 'option exists' do
    let(:option) { create :option }

    it 'adds the option to the model' do
      expect {
        post api_v1_model_add_option_path(model),
             params: { option_id: option.id }
      }.to change(model.options, :count).from(0).to(1)
    end

    it 'returns ok status' do
      post api_v1_model_add_option_path(model),
           params: { option_id: option.id }

      expect(response).to have_http_status :ok
    end

    it 'returns model with options' do
      post api_v1_model_add_option_path(model),
           params: { option_id: option.id }

      option_json = json(response.body)['data']

      expect(option_json['type']).to eq 'models'
      expect(option_json['attributes']['name']).to eq model.name
    end
  end

  context 'when an option does not exist' do
    let(:missing_id) { 404 }

    before do
      post api_v1_model_add_option_path(model),
           params: { option_id: missing_id }
    end

    it_behaves_like 'missing resource', Option
  end

  context 'when model already has option' do
    let(:option) { create :option }

    before do
      model.options << option
      post api_v1_model_add_option_path(model),
           params: { option_id: option.id }
    end

    it 'returns unprocessable entity status' do
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'returns proper error response' do
      error_json = json(response.body)['errors']
      expect(error_json.first['detail'])
        .to eq "Model with id: #{model.id} already has this option."
    end
  end
end
