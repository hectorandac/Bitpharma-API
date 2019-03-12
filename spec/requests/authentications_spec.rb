# frozen_string_literal: true

require 'rails_helper'

def extract_token(response)
  token = response.headers['Authorization']
  token = token.dup
  token.slice! 'Bearer '
  token
end

def decode_jwt_token(response)
  token = extract_token(response)
  JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'])
end

RSpec.describe 'POST /login', type: :request do
  let(:url) { '/api/login' }

  context 'When the params are correct' do
    before do
      user = create :user
      params = {
        user: {
          email: user.email,
          password: user.password
        }
      }

      headers = {
        'Content-Type' => 'application/json'
      }

      post('/api/login', params: params.to_json, headers: headers)
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JWT token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decode_jwt_token(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end
end

RSpec.describe 'DELETE /logout', type: :request do
  let(:url) { '/api/logout' }

  it 'returns 204, no content' do
    delete url
    expect(response).to have_http_status(204)
  end
end
