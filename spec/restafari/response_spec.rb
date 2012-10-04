require "spec_helper"

describe Restafari::Response do

  let(:value) { "some value" }
  let(:body) { {"x"=>value} }

  describe "creating a new response" do

    def new_response
      Restafari::Response.new(response).data
    end

    context "when the response is a Hash" do
      let(:response){ { body:body } }
      it "should use the response body" do
        new_response.should eq body
      end
    end

    context "when the response is a Faraday::Response" do

      let(:response){ Faraday::Response.new(body: body) }

      context "when the response body is parseable to JSON" do
        it "should parse the response body to JSON" do
          new_response.should eq body
        end
      end

      context "when the response body is not parseable to JSON" do
        let(:body){ "not parseable to JSON" }
        it "should use the whole response" do
          new_response.should eq body
        end
      end
    end

    context "when the response is nil" do
      let(:response){ nil }
      it "should be nil" do
        new_response.should be_nil
      end
    end

  end


  describe "accessing the response body data" do

    let(:response){ { body: {"key" => value} } }

    it "should allow access to response keys as methods" do
      Restafari::Response.new(response).key.should eq value
    end

  end


end