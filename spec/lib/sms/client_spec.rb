require 'rails_helper'

describe Sms::Client do
  context 'singleton' do
    it { expect(Sms::Client.instance).to eq(Sms::Client.instance) }
  end
end
