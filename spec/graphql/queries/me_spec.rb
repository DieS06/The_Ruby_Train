require "rails_helper"

RSpec.describe "currentUser query" do
  let(:user) { create(:user, :active) }
  let(:ctx)  { { current_user: user } }

  it "Returns data of the authenticated user" do
    query = <<~GRAPHQL
      query {
        currentUser { id email fullName }
      }
    GRAPHQL

    result = TheRubyTrainSchema.execute(query, context: ctx)
    expect(result.dig("data", "currentUser", "email")).to eq(user.email)
  end
end
