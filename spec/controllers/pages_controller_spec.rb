require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #secure" do
    it "returns http success" do
      get :secure
      expect(response).to have_http_status(:success)
    end
  end

end
