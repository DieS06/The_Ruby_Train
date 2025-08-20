# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }
  
  describe "GET /profiles" do
    context "when user is authenticated" do
      before { sign_in user }
      
      it "returns http success" do
        get "/profiles"
        expect(response).to have_http_status(:success)
      end
      
      it "renders the profiles index template" do
        get "/profiles"
        expect(response).to render_template("profiles/index")
      end
      
      it "uses application layout" do
        get "/profiles"
        expect(response).to render_template(layout: "application")
      end
      
      it "authorizes user to read themselves" do
        expect(controller).to receive(:authorize!).with(:read, user)
        get "/profiles"
      end
    end
    
    context "when user is not authenticated" do
      it "redirects to login" do
        get "/profiles"
        expect(response).to have_http_status(:redirect)
      end
      
      it "does not render the profiles template" do
        get "/profiles"
        expect(response).not_to render_template("profiles/index")
      end
    end
    
    context "authorization scenarios" do
      before { sign_in user }
      
      context "when user cannot read their own profile" do
        before do
          allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
        end
        
        it "raises access denied error" do
          expect {
            get "/profiles"
          }.to raise_error(CanCan::AccessDenied)
        end
      end
      
      context "with different user roles" do
        let(:admin) { create(:user).tap { |u| u.add_role(:admin) } }
        let(:student) { create(:user).tap { |u| u.add_role(:student) } }
        
        it "allows admin to access profiles" do
          sign_in admin
          get "/profiles"
          expect(response).to have_http_status(:success)
        end
        
        it "allows student to access profiles" do
          sign_in student
          get "/profiles"
          expect(response).to have_http_status(:success)
        end
      end
    end
    
    context "with user that has profile" do
      let!(:profile) { create(:profile, user: user) }
      
      before { sign_in user }
      
      it "successfully loads when user has profile" do
        get "/profiles"
        expect(response).to have_http_status(:success)
      end
    end
    
    context "with user that has no profile" do
      before { sign_in user }
      
      it "successfully loads even without profile" do
        get "/profiles"
        expect(response).to have_http_status(:success)
      end
    end
  end
  
  describe "controller behavior" do
    before { sign_in user }
    
    it "requires authentication" do
      expect(controller).to receive(:authenticate_user!)
      get "/profiles"
    end
    
    it "sets current_user correctly" do
      get "/profiles"
      expect(controller.current_user).to eq(user)
    end
  end
  
  describe "error handling" do
    context "when rendering fails" do
      before do
        sign_in user
        allow(controller).to receive(:render).and_raise(ActionView::MissingTemplate)
      end
      
      it "propagates rendering errors" do
        expect {
          get "/profiles"
        }.to raise_error(ActionView::MissingTemplate)
      end
    end
  end
end
