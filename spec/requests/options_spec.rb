require 'rails_helper'

RSpec.describe 'Options', type: :request do
  after(:all) { Option.destroy_all }

  describe 'POST /options' do

    it 'returns created status code' do
      post api_v1_options_path, params: { option: attributes_for(:option) }
      expect(response).to have_http_status '201'
    end

    it 'creates a option' do
      expect {
        post api_v1_options_path, params: { option: attributes_for(:option) }
      }.to change(Option, :count).by(1)
    end

    it 'returns created option as json' do
      option_params = attributes_for :option
      post api_v1_options_path, params: { option: option_params }

      option_json = json(response.body)['data']
      expect(option_json['type']).to eq 'options'
      expect(option_json['attributes']['name']).to eq option_params[:name]
    end

    context 'when option already exists' do
      let(:existing_option) { create :option }

      before do
        post api_v1_options_path, params: { option: existing_option.attributes }
      end

      it 'returns an error code' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper error response' do
        error_on_name = json(response.body)['errors'].first
        expect(error_on_name['source']['pointer']).to eq '/data/attributes/name'
        expect(error_on_name['detail']).to eq 'has already been taken'
      end
    end
  end

  describe 'PATCH /options/:id' do
    context 'when changing attribute' do
      let(:option) { create :option }
      let(:new_name) { 'Smoke Screen' }

      before do
        patch api_v1_option_path(option), params: { option: { name: new_name } }
      end

      it 'returns correct status code' do
        expect(response).to have_http_status '200'
      end

      it 'updates the option' do
        expect(option.reload.name).to eq new_name
      end

      it 'returns the modified option as json' do
        option_json = json(response.body)['data']
        expect(option_json['attributes']['name']).to eq new_name
      end
    end

    context 'when making an error' do
      it 'returns status code' do
        option1 = create :option
        option2 = create :option
        patch api_v1_option_path(option2),
              params: { option: { name: option1.name } }

        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when option not found' do
      before do
        allow(Option).to receive(:find) { raise ActiveRecord::RecordNotFound }
        option = create :option
        patch api_v1_option_path(option)
      end

      it_behaves_like 'missing resource', Option
    end
  end


end
