require "rails_helper"

describe SmsController, :type => :routing do
  it "received_user_response routes properly" do
    expect(:post => "/sms/received_user_response").to route_to(
      :controller => "sms",
      :action => "received_user_response"
    )
  end
end
