# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# Thin HTTP wrapper around football-data.org v4.
# Reads the API token lazily from ENV so dev/test envs without a token still boot.
#
# Free tier rate limit: 10 req/min — easily enough for our cron + manual triggers.
# See https://docs.football-data.org/general/v4/policies.html
module Results
  class FootballDataClient

    BASE_URL     = 'https://api.football-data.org/v4'
    OPEN_TIMEOUT = 5   # seconds — TCP connect
    READ_TIMEOUT = 15  # seconds — wait for response body

    # Raised when the env var is missing (so we fail fast at call-time, not boot).
    class MissingTokenError < StandardError; end

    # Raised on any non-2xx response or transport-level error.
    # status is nil for transport errors (timeout, DNS, etc).
    class ApiError < StandardError
      attr_reader :status, :body

      def initialize(message, status: nil, body: nil)
        super(message)
        @status = status
        @body   = body
      end
    end

    # Fetches matches for a competition. Returns the parsed JSON Hash.
    #
    # competition_code: defaults to FOOTBALL_DATA_COMPETITION_CODE (set in
    #   config/initializers/01_constants.rb based on IS_WM / IS_EM):
    #     'WC' = FIFA World Cup
    #     'EC' = UEFA European Championship
    #   See https://docs.football-data.org/general/v4/lookup_tables.html
    # status: optional filter, e.g. 'FINISHED'. nil = all.
    def fetch_competition_matches(competition_code: FOOTBALL_DATA_COMPETITION_CODE, status: nil)
      path  = "/competitions/#{competition_code}/matches"
      query = status ? { status: status } : {}
      get_json(path, query)
    end

    private

    def token
      value = ENV['FOOTBALL_DATA_API_TOKEN']
      raise MissingTokenError, 'FOOTBALL_DATA_API_TOKEN is not set' if value.blank?
      value
    end

    def get_json(path, query = {})
      uri = URI("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(query) if query.any?

      response = perform_request(uri)
      parse_response(response, uri)
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      raise ApiError.new("Timeout contacting football-data.org: #{e.message}")
    rescue SocketError, Errno::ECONNREFUSED, Errno::ECONNRESET => e
      raise ApiError.new("Network error contacting football-data.org: #{e.message}")
    end

    def perform_request(uri)
      http              = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl      = (uri.scheme == 'https')
      http.open_timeout = OPEN_TIMEOUT
      http.read_timeout = READ_TIMEOUT

      request = Net::HTTP::Get.new(uri.request_uri)
      request['X-Auth-Token'] = token
      request['Accept']       = 'application/json'

      http.request(request)
    end

    def parse_response(response, uri)
      status = response.code.to_i
      body   = response.body

      unless status.between?(200, 299)
        raise ApiError.new(
          "football-data.org responded #{status} for #{uri}",
          status: status,
          body:   body
        )
      end

      JSON.parse(body)
    rescue JSON::ParserError => e
      raise ApiError.new("Invalid JSON from football-data.org: #{e.message}", status: status, body: body)
    end

  end
end
