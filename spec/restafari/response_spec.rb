require "spec_helper"

describe Restafari::Response do

  it "should handle response of type hash" do
    Restafari::Response.new({body:{"x"=>2}}).x.should == 2
  end
end