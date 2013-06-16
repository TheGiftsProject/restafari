require 'singleton'


module Restafari
  class Configuration
    include Singleton

    def initialize

      @defaults = {
        base_url: "",
        http_method: :post,
        scheme: :http,
        timeout: 60,
        before_request: [],
        after_response: []
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
      @defaults[:before_request] << block if block_given?
    end

    def after_response(&block)
      @defaults[:after_response] << block if block_given?
    end

    def run_before_request_hook(*params)
      @defaults[:before_request].each do |hook|
        hook.call(*params)
      end
    end

    def run_after_response_hook(*params)
      @defaults[:after_response].each do |hook|
        hook.call(*params)
      end
    end

  end
end
