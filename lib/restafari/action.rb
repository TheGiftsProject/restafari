require "faraday"
require 'uri'

module Restafari
  module Action

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def action(name, *args)

        case args.length
          when 0
            path = "/#{name.to_s}"
          when 1
            if args[0].is_a? String
              path = args[0]
            else
              path = "/#{name}"
              default_params = args[0]
            end
          else
            path = args[0]
            default_params = args[1]
        end

        default_params ||= {}

        define_singleton_method(name) do |params={}, &block|
          execute!(path, default_params.merge(params), &block)
        end


        define_singleton_method("#{name}_url") do |params={}, run_before_req_hooks=true|
          params = default_params.merge(params)
          Restafari.config.run_before_request_hook(params) if run_before_req_hooks
          conn = Faraday.new(url: Restafari.config.url, params: params)
          conn.build_url(path)
        end
      end

      private
      def execute!(path, params, &block)
        conn = Faraday.new(url: Restafari.config.url)
        Restafari.config.run_before_request_hook(params)

        headers = params[:headers] || {}
        headers.delete_if { |_, v| v.nil? }
        params.delete(:headers) #so we dont send it as part of the params

        encode_cookie(headers)

        result = conn.send(Restafari.config.http_method, path, params) do |req|
          req.headers.update(headers)
          req.options[:timeout] = Restafari.config.timeout
          @req = req
          yield req if block_given?
        end
        result.env[:req] = Hash[@req.each_pair.to_a]
        Restafari.config.run_after_response_hook(result)
        Restafari::Response.new(result)
      end

      def encode_cookie(headers)
        return if headers.nil?
        cookie = headers[:cookie]
        if cookie
          if cookie.is_a? String
            headers[:cookie] = cookie
          else
            headers[:cookie] = headers[:cookie].map { |k, v| "#{k}=#{v}" }.join("; ")
          end
        end
      end
    end
  end
end
