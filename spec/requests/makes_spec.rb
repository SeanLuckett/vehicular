require 'rails_helper'

RSpec.describe 'Makes', type: :request do
  after(:all) { Make.destroy_all }

  describe 'POST /makes' do

    it 'returns created status code' do
      post api_v1_makes_path, params: { make: attributes_for(:make) }
      expect(response).to have_http_status '201'
    end

    it 'creates a make' do
      expect {
        post api_v1_makes_path, params: { make: attributes_for(:make) }
      }.to change(Make, :count).by(1)
    end

    it 'returns created make as json' do
      make_params = attributes_for :make
      post api_v1_makes_path, params: { make: make_params }

      make_json = json(response.body)['data']
      expect(make_json['type']).to eq 'makes'
      expect(make_json['attributes']['name']).to eq make_params[:name]
    end

    context 'when make already exists' do
      let(:existing_make) { create :make }

      before do
        post api_v1_makes_path, params: { make: existing_make.attributes }
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

  describe 'PATCH /makes/:id' do
    context 'when changing attribute' do
      let(:make) { create :make }
      let(:new_name) { 'Honda' }

      before do
        patch api_v1_make_path(make), params: { make: { name: new_name } }
      end

      it 'returns correct status code' do
        expect(response).to have_http_status '200'
      end

      it 'updates the make' do
        expect(make.reload.name).to eq new_name
      end

      it 'returns the modified make as json' do
        make_json = json(response.body)['data']
        expect(make_json['attributes']['name']).to eq new_name
      end
    end

    context 'when making an error' do
      it 'returns status code' do
        make1 = create :make
        make2 = create :make
        patch api_v1_make_path(make2), params: { make: { name: make1.name } }
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when make not found' do
      before do
        allow(Make).to receive(:find) { raise ActiveRecord::RecordNotFound }
        make = create :make
        patch api_v1_make_path(make)
      end

      it_behaves_like 'missing resource', Make
    end
  end

  describe 'GET /makes' do
    before do
      2.times { create :make }
      get api_v1_makes_path
    end

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'gets list of makes' do
      list_json = json(response.body)['data']
      expect(list_json.length).to eq Make.count
    end
  end

  describe 'GET /make/:id' do
    let(:make) { create :make }

    before { get api_v1_make_path(make) }

    it 'returns ok status code' do
      expect(response).to have_http_status :ok
    end

    it 'returns the make' do
      make_json = json(response.body)['data']
      expect(make_json['id']).to eq make.id.to_s
    end

    context 'when make not found' do
      before do
        make = create :make
        allow(Make).to receive(:find) { raise ActiveRecord::RecordNotFound }

        get api_v1_make_path(make)
      end

      it_behaves_like 'missing resource', Make
    end
  end

  describe 'DELETE /make/:id' do
    let!(:deletable) { create :make }

    it 'returns no content status' do
      delete api_v1_make_path(deletable)
      expect(response).to have_http_status :no_content
    end

    it 'only deletes make' do
      expect {
        delete api_v1_make_path(deletable)
      }.to change(Make, :count).by(-1)
    end

    context 'when make not found' do
      before do
        allow(Make).to receive(:find) { raise ActiveRecord::RecordNotFound }

        delete api_v1_make_path(deletable)
      end

      it_behaves_like 'missing resource', Make
    end
  end
end
