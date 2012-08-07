require "faraday"

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

        define_singleton_method(name) do |params={}|
          execute!(path, default_params.merge(params))
        end

        define_singleton_method("#{name}_url") do |params={}|
          params = default_params.merge(params)
          Restafari.config.run_before_request_hook(params)
          conn = Faraday.new(url: Restafari.config.url, params: params)
          conn.build_url(path)
        end

      end

      private
      def execute!(path, params)
        conn = Faraday.new(url: Restafari.config.url)
        Restafari.config.run_before_request_hook(params)
        result = conn.send(Restafari.config.http_method, path, params) do |req|
          @req = req
        end
        result.env[:req] = Hash[@req.each_pair.to_a]
        Restafari.config.run_after_response_hook(result)
        Restafari::Response.new(result)
      end
    end
  end
end
