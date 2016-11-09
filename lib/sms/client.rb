require 'twilio-ruby'

module SMS
  class Client
    def initialize
      @client = Twilio::REST::Client.new(
        Rails.application.secrets.twilio_account_id,
        Rails.application.secrets.twilio_auth_token,
      )
      @somo_phone_number = Rails.application.secrets.somo_phone_number
    end

    def send(message, phone_number)
      @client.account.messages.create({
        :to => phone_number,
        :from => @somo_phone_number,
        :body => message,
      })
    end
  end
end
