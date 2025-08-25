# frozen_string_literal: true

# == RolesController Request Spec
#
# @!group 02 - Test / Users
#

require "rails_helper"

RSpec.describe "RolesController", type: :request do
  # Create from user factory
  let(:user) { create(:user) }

  # Verifies access controls for GET /users/:user_id/roles.
  describe "GET /users/:user_id/roles" do
    let(:path) { "/users/#{user.id}/roles" }

    context "when unauthenticated" do
      it "redirects to sign in" do
        get path
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(home_path)
      end
    end

    # Covers: Devise authentication and CanCanCan authorization (class: false).
    context "when authenticated but unauthorized" do
      it "raises or denies access (marking pending until Ability is known)" do
        sign_in user
        get path
        pending("Define Ability rule for :read, :roles or adjust rescue behavior for HTML")
        # Expectativas posibles (ajusta según tu rescue_from en HTML):
        # expect(response).to have_http_status(:forbidden)
        # or a redirect with a flash
      end
    end

    context "when authenticated and authorized" do
      it "renders the roles/index HTML" do
        sign_in user
        get path

        # Inyectar Ability luego del request (truco para request specs):
        # Rails expone el último controller usado por el router
        controller_obj = Rails.application.routes.recognize_path(path) rescue nil
        # Si necesitas stub real del current_ability, usa rack middleware or switch a controller spec.
        # Alternativa práctica: usar controller spec o system spec. Para mantener request spec:
        # hacemos otra petición con stub.

        # Repite el request stubeando current_ability:
        allow_any_instance_of(RolesController).to receive(:current_ability).and_wrap_original do |m, *args|
          ability = m.call(*args)
          ability.can :read, :roles
          ability
        end

        get path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("roles/index") # opcional, ajusta a un selector confiable
      end
    end
  end
end
# @!endgroup
