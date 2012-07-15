require 'rubygems'
require 'rspec'
require "webmock"
require 'restafari'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end


Restafari.config.base_url = "www.example.com"
WebMock::stub_request(:post, "http://#{Restafari.config.base_url}/").to_return(:status => 200, :body => "{}", :headers => {})
WebMock::stub_request(:post, "http://#{Restafari.config.base_url}/some_method").to_return(:status => 200, :body => "{}", :headers => {})
unless defined?(RM_HOME)
  # this is here to allow teamcity to run with spork
  RM_HOME=File.expand_path("~/BuildAgent/plugins/rake-runner")
  $:.unshift(RM_HOME + "/rb/patch/bdd")
  $:.unshift(RM_HOME + "/rb/patch/common")
end

