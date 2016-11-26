require 'rails_helper'

RSpec.describe Response, type: :model do
  context "response is missing answer" do
    subject { FactoryGirl.build(:response, answer: "") }
    it { is_expected.not_to be_valid }
  end
end
