require "rails_helper"

RSpec.describe "PUT /users/:id/state" do
  # Test user, administrator role with factory.
  let(:admin)  { create(:user, :active).tap { _1.add_role :admin } }
  let(:target) { create(:user, :pending)   }

  it "Changes state if it's admin" do
    # Create JWT token.
    token = Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first
    # Update user state, with valid header.
    put "/users/#{target.id}/state",
        headers: { "Authorization" => "Bearer #{token}" },
        params:  { state: "active" }
    # Expect response to be successful and state to be updated.
    expect(response).to have_http_status(:ok)
    expect(target.reload.state).to eq("active")
  end
end
