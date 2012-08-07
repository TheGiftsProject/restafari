require "spec_helper"
describe Restafari::Action do

  it "should be able to pass default parameters without path" do
    class SomeAction
      include Restafari::Action
      action :some_method, { b: 1 }
    end

    SomeAction.should_receive(:execute!).with("/some_method", { b: 1 }).once
    SomeAction.some_method()
  end

  it "should be able to receive a path to an action" do
    class SomeAction
      include Restafari::Action
      action :some_method, "/action"
    end

    SomeAction.should_receive(:execute!).with("/action", kind_of(Hash)).once
    SomeAction.some_method()
  end

  it "should should run the before_request hook before each request" do
    class SomeAction
      include Restafari::Action
      action :some_method
    end

    Restafari.config.before_request do |params|
      params[:test] = true
    end


    Restafari.config.should_receive(:run_before_request_hook).once.and_return({test: true})
    SomeAction.some_method()

    Restafari.config.defaults[:before_request].clear
  end

  it "should run the after response hook after each response" do
    class SomeAction
      include Restafari::Action
      action :some_method
    end

    Restafari.config.after_response do |response|
      "aaa"
    end


    Restafari.config.should_receive(:run_after_response_hook).once.and_return("aaa")
    SomeAction.some_method()
  end

  it "should allow accessing the action url" do
    class UrlTest
      include Restafari::Action
      action :url_method
    end
    UrlTest.url_method_url(rt:2).to_s.should eq "http://www.example.com/url_method?rt=2"
  end

end
