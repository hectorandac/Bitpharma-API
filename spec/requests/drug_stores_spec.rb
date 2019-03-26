# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/drug_store', type: :request do
  let(:url) { '/api/drug_store' }
  let(:drugstore) { create(:drug_store) }

  context 'Get the information of a drugstore' do
    before { get url, params: { drugstore_id: drugstore.id } }
    it 'should return 200' do
      expect(response.status).to eq 200
    end

    it 'returns a pharmacy' do
      expect(response.body).to match_response_schema('drug_store')
    end
  end

  context 'Drugstore does not exist' do
    before { get url, params: { drugstore_id: drugstore.id + 1 } }
    it 'should return 404' do
      expect(response.status).to eq 404
    end

    it 'should return not found message' do
      expect(response.body).to eq 'Drugstore does not exist.'
    end
  end

end

RSpec.describe 'POST /api/drug_store/image', type: :request do
  let(:url) { '/api/drug_store/image' }
  let(:user) { create(:user) }
  let(:drugstore) { create(:drug_store, user: user) }

  context 'Upload image to an store' do
    before do
      @file = fixture_file_upload('images/store_front_image.jpg', 'image/*')
      params = {}
      params['image'] = @file
      params['drugstore_id'] = drugstore.id

      headers = {
        'Content-Type' => 'application/json',
        :Authorization => sign_in(user)
      }

      post url, params: params, headers: headers
    end

    it 'should return 200' do
      expect(response.status).to eq 200
    end

    it 'should return an structure like an image' do
      expect(response.body).to match_response_schema('pictures')
    end
  end

  context 'Upload by an unathorized user' do
    before do
      unauthorized_user = create(:user)

      @file = fixture_file_upload('images/store_front_image.jpg', 'image/*')
      params = {}
      params['image'] = @file
      params['drugstore_id'] = drugstore.id

      headers = {
        'Content-Type' => 'application/json',
        :Authorization => sign_in(unauthorized_user)
      }

      post url, params: params, headers: headers
    end

    it 'should return 401' do
      expect(response.status).to eq 401
    end

    it 'should send an unauthorized user message' do
      expect(response.body).to eq 'User is not allowed to perform this action.'
    end
  end

  context 'Upload to an invalid id' do
    before do
      @file = fixture_file_upload('images/store_front_image.jpg', 'image/*')
      params = {}
      params['image'] = @file
      params['drugstore_id'] = drugstore.id + 1

      headers = {
          'Content-Type' => 'application/json',
          :Authorization => sign_in(user)
      }

      post url, params: params, headers: headers
    end

    it 'should return 404' do
      expect(response.status).to eq 404
    end
  end
end

RSpec.describe 'POST /api/drug_store', type: :request do
  let(:url) { '/api/drug_store' }
  let(:user) { create(:user) }
  let(:params) do
    {
      drug_store: {
        name: Faker::Company.name,
        description: Faker::Company.catch_phrase,
        user_id: user.id
      }
    }
  end

  context 'When user is not authenticated' do
    before { post url, params: params }

    it 'returns 401' do
      expect(response.status).to eq 401
    end

    it 'returns unauthorized message' do
      expect(response.body).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  context 'When data is correct, the user is authenticated and an admin' do
    before do
      headers = {
        'Content-Type' => 'application/json',
        :Authorization => sign_in(user)
      }
      post url, params: params.to_json, headers: headers
    end

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns a new pharmacy' do
      expect(response.body).to match_response_schema('drug_store')
    end
  end
end
