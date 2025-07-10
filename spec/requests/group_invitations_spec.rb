require 'rails_helper'

RSpec.describe "GroupInvitations", type: :request do
  describe "GET /group_invitations/accept/:token" do
    let(:inviter) { create(:user) }
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:membership) do
      create(:group_membership,
        user: user,
        group: group,
        invited_by: inviter.id,
        invited_token: "test-token",
        state: :invited
      )
    end

    it "joins the group when token is valid" do
      get accept_group_invitation_path(token: membership.invited_token)

      expect(response).to have_http_status(:ok)
      expect(membership.reload.state).to eq("joined")
      expect(membership.joined_at).to be_present
    end

    it "returns 404 when token is invalid" do
      get accept_group_invitation_path(token: "wrong-token")
      expect(response).to have_http_status(:not_found)
    end
  end
end
