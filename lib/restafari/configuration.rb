require 'singleton'


module Restafari
  class Configuration
    include Singleton

    def initialize

      @defaults = {
        base_url: "",
        http_method: :post,
        scheme: :http,
        before_request: nil,
      }

      define_singleton_method :defaults do
        @defaults
      end
    end

    def method_missing(name, *args)
      name_stripped = name.to_s.sub(/[\?=]$/, '').to_sym
      return super unless @defaults.key?(name_stripped)

      if name.to_s.end_with?('=')
        @defaults[name_stripped] = args.first
      else
        @defaults[name_stripped]
      end
    end

    def url
      "#{Restafari.config.scheme}://#{Restafari::config.base_url}"
    end

    def before_request(&block)
      @before_request = block if block_given?
    end

    def run_before_request_hook(*params)
      @before_request.call(*params)
    end

  end
end