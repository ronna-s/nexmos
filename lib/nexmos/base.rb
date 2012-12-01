module Nexmos
  class Base

    def initialize(key = ::Nexmos.api_key, secret = ::Nexmos.api_secret)
      @default_params = {
        'api_key' => key,
        'api_secret' => secret
      }
    end

    def connection
      self.class.connection.dup
    end

    def make_api_call(args, params = {})
      params.stringify_keys!
      params.merge!(@default_params)
      if args[:required]
        required = params.slice(*args[:required])
        unless required.keys.sort == args[:required].sort
          missed = (args[:required] - required.keys).join(',')
          raise ArgumentError, "#{missed} params required"
        end
      end
      method = args[:method]
      url = args[:url]
      res = connection.__send__(method, url, params)
      Hashie::Mash.new(res.body.merge(:success? => res.success?))
    end

    class << self

      def define_api_calls(key)
        ::Nexmos.apis[key].each do |k,v|
          define_method(k) do |params = {}|
            make_api_call(v, params)
          end
        end
      end

      def faraday_options
        {
          :url => 'https://rest.nexmo.com',
          :headers => {
            :accept =>  'application/json',
            :user_agent => ::Nexmos.user_agent
          }
        }
      end

      def connection
        @connection ||= Faraday::Connection.new(faraday_options) do |conn|
          conn.request  :url_encoded
          conn.response :json, :content_type => /\bjson$/
          conn.response :rashify
          conn.adapter  Faraday.default_adapter
        end
      end
    end # self
  end # Base
end # Nexmos