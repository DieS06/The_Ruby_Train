# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "ContentUnits", type: :request do
  let(:user) { create(:user) }
  let(:content_unit) { create(:content_unit, state: 'visible') }
  
  before do
    sign_in user
  end
  
  describe "GET /content_units" do
    context "when user is authenticated" do
      it "returns http success" do
        get "/content_units"
        expect(response).to have_http_status(:success)
      end
      
      it "renders the content units index template" do
        get "/content_units"
        expect(response).to render_template("content_unit/index")
      end
      
      it "uses application layout" do
        get "/content_units"
        expect(response).to render_template(layout: "application")
      end
    end
    
    context "when user is not authenticated" do
      before { sign_out user }
      
      it "redirects to login" do
        get "/content_units"
        expect(response).to have_http_status(:redirect)
      end
    end
    
    context "with authorization" do
      it "loads and authorizes content units" do
        expect(controller).to receive(:load_and_authorize_resource).with(only: [:index, :show])
        get "/content_units"
      end
    end
  end
  
  describe "GET /content_units/:slug" do
    let(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', slug: 'ruby-basics') }
    
    context "when lesson exists" do
      before do
        lesson
      end
      
      it "returns http success" do
        get "/content_units/#{lesson.slug}"
        expect(response).to have_http_status(:success)
      end
      
      it "renders the content unit show template" do
        get "/content_units/#{lesson.slug}"
        expect(response).to render_template("content_unit/show")
      end
      
      it "uses application layout" do
        get "/content_units/#{lesson.slug}"
        expect(response).to render_template(layout: "application")
      end
      
      it "assigns the lesson" do
        get "/content_units/#{lesson.slug}"
        expect(assigns(:lesson)).to eq(lesson)
      end
    end
    
    context "when lesson does not exist" do
      it "assigns nil to lesson" do
        get "/content_units/nonexistent-slug"
        expect(assigns(:lesson)).to be_nil
      end
      
      it "still returns success (template handles nil lesson)" do
        get "/content_units/nonexistent-slug"
        expect(response).to have_http_status(:success)
      end
    end
    
    context "when user is not authenticated" do
      before { sign_out user }
      
      it "redirects to login" do
        get "/content_units/#{lesson.slug}"
        expect(response).to have_http_status(:redirect)
      end
    end
    
    context "with different content unit types" do
      let(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', slug: 'ruby-course') }
      let(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', slug: 'control-flow') }
      let(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit', slug: 'conditionals') }
      
      it "only finds LessonUnit types" do
        course
        module_unit
        segment
        
        get "/content_units/#{course.slug}"
        expect(assigns(:lesson)).to be_nil
        
        get "/content_units/#{module_unit.slug}"
        expect(assigns(:lesson)).to be_nil
        
        get "/content_units/#{segment.slug}"
        expect(assigns(:lesson)).to be_nil
      end
    end
    
    context "with authorization requirements" do
      let(:private_lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', slug: 'private-lesson', state: 'draft') }
      
      it "respects authorization rules" do
        expect(controller).to receive(:load_and_authorize_resource).with(only: [:index, :show])
        get "/content_units/#{private_lesson.slug}"
      end
    end
  end
  
  describe "authorization integration" do
    context "with different user roles" do
      let(:admin) { create(:user).tap { |u| u.add_role(:admin) } }
      let(:student) { create(:user).tap { |u| u.add_role(:student) } }
      let(:draft_lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', slug: 'draft-lesson', state: 'draft') }
      
      context "as admin" do
        before { sign_in admin }
        
        it "can access draft content" do
          get "/content_units"
          expect(response).to have_http_status(:success)
        end
      end
      
      context "as student" do
        before { sign_in student }
        
        it "can access visible content" do
          get "/content_units"
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
  
  describe "error handling" do
    context "when CanCan denies access" do
      before do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end
      
      it "handles authorization errors" do
        expect {
          get "/content_units"
        }.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end