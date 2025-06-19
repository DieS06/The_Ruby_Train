require 'rails_helper'

RSpec.describe "Roles", type: :request do
  describe "GET /assign" do
    it "returns http success" do
      get "/roles/assign"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /remove" do
    it "returns http success" do
      get "/roles/remove"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/roles/index"
      expect(response).to have_http_status(:success)
    end
  end

end
