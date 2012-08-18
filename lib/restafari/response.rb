require 'json'
module Restafari
  class Response
    attr_reader :data, :resp

    def initialize(resp)
      @resp = resp
      @data = @resp.is_a?(Hash) ? @resp[:body] : JSON.parse(@resp.body)
    end

    def [](i)
      case i
        when Symbol
          @data[i.to_s]
        else
          @data[i]
      end
    end

    def method_missing(method_id, *args)
      return super unless @data.key?(method_id.to_s)
      self[method_id]
    rescue NoMethodError=>ex
      raise NoMethodError.new("no #{method_id} method, response: #{@resp}", "no method error")
    end
  end
end
