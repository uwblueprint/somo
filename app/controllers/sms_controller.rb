class SmsController < ApplicationController
  # Twilio will call various endpoints in this controller
  skip_before_filter :verify_authenticity_token

  def received_user_response
    # Twilio calls this endpoint when a user sends a message to us
    user_response = params[:Body]
    from          = params[:From]
    # TODO(Chris): Implement replying logic here
    puts user_response
    puts from
    head :ok
  end
end
