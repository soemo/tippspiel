require 'rails_helper'

describe Results::FootballDataClient do

  subject(:client) { described_class.new }

  let(:fake_http) { instance_double(Net::HTTP) }

  before do
    allow(Net::HTTP).to receive(:new).and_return(fake_http)
    allow(fake_http).to receive(:use_ssl=)
    allow(fake_http).to receive(:open_timeout=)
    allow(fake_http).to receive(:read_timeout=)
  end

  def fake_response(code, body)
    instance_double(Net::HTTPResponse, code: code.to_s, body: body)
  end

  describe '#fetch_competition_matches' do
    context 'when the token is missing' do
      before { ENV.delete('FOOTBALL_DATA_API_TOKEN') }

      it 'raises MissingTokenError' do
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::MissingTokenError)
      end
    end

    context 'with a valid token' do
      before { ENV['FOOTBALL_DATA_API_TOKEN'] = 'test-token' }

      it 'parses a 200 JSON body' do
        allow(fake_http).to receive(:request).and_return(fake_response(200, '{"matches":[{"id":1}]}'))
        result = client.fetch_competition_matches
        expect(result).to eq('matches' => [{ 'id' => 1 }])
      end

      it 'raises ApiError on 401' do
        allow(fake_http).to receive(:request).and_return(fake_response(401, '{"message":"unauthorised"}'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError) { |e|
          expect(e.status).to eq 401
          expect(e.body).to include('unauthorised')
        }
      end

      it 'raises ApiError on 429 rate limit' do
        allow(fake_http).to receive(:request).and_return(fake_response(429, 'rate limit'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError) { |e|
          expect(e.status).to eq 429
        }
      end

      it 'raises ApiError on 500' do
        allow(fake_http).to receive(:request).and_return(fake_response(500, 'oops'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError) { |e|
          expect(e.status).to eq 500
        }
      end

      it 'raises ApiError on open timeout' do
        allow(fake_http).to receive(:request).and_raise(Net::OpenTimeout.new('timeout'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError, /Timeout/)
      end

      it 'raises ApiError on read timeout' do
        allow(fake_http).to receive(:request).and_raise(Net::ReadTimeout.new('timeout'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError, /Timeout/)
      end

      it 'raises ApiError on socket error' do
        allow(fake_http).to receive(:request).and_raise(SocketError.new('dns'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError, /Network/)
      end

      it 'raises ApiError on malformed JSON' do
        allow(fake_http).to receive(:request).and_return(fake_response(200, 'not-json'))
        expect {
          client.fetch_competition_matches
        }.to raise_error(Results::FootballDataClient::ApiError, /Invalid JSON/)
      end

      it 'sends the X-Auth-Token header' do
        captured = nil
        allow(fake_http).to receive(:request) do |req|
          captured = req
          fake_response(200, '{"matches":[]}')
        end
        client.fetch_competition_matches
        expect(captured['X-Auth-Token']).to eq 'test-token'
      end

      it 'defaults to the tournament-wide FOOTBALL_DATA_COMPETITION_CODE constant' do
        captured_path = nil
        allow(fake_http).to receive(:request) do |req|
          captured_path = req.path
          fake_response(200, '{"matches":[]}')
        end
        client.fetch_competition_matches
        expect(captured_path).to include("/competitions/#{FOOTBALL_DATA_COMPETITION_CODE}/matches")
      end
    end
  end

end
