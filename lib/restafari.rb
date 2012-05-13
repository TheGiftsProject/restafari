require_relative 'restafari/action.rb'

module Restafari

  autoload :Configuration,  'restafari/configuration'
  autoload :Response, 'restafari/response'

  def self.config
    Configuration.instance
  end

end