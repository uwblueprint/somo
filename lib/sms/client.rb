require 'twilio-ruby'

module Sms
  class Client
    include Singleton

    def initialize
      @client = Twilio::REST::Client.new(
        Rails.application.secrets.twilio_account_id || '',
        Rails.application.secrets.twilio_auth_token || '',
      )
      @somo_phone_number = Rails.application.secrets.somo_phone_number
    end

    def send(phone_number, message)
      @client.account.messages.create({
        :to => phone_number,
        :from => @somo_phone_number,
        :body => message,
      })
    end
  end
end
