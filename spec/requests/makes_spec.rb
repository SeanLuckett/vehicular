require 'rails_helper'

RSpec.describe 'Makes', type: :request do
  describe 'POST /makes' do
    it 'returns correct status code' do
      post '/api/v1/makes.json', params: { make: attributes_for(:make) }
      expect(response.status).to be 201
    end

    it 'creates a make' do
      expect {
        post '/api/v1/makes.json', params: { make: attributes_for(:make) }
      }.to change(Make, :count).by(1)
    end

    it 'returns newly created make as json' do
      make_params = attributes_for :make
      post '/api/v1/makes.json', params: { make: make_params}

      make_json = json(response.body)['data']
      expect(make_json['type']).to eq 'makes'
      expect(make_json['attributes']['name']).to eq make_params[:name]
    end
  end
end
