# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::UpdateProfile, type: :graphql do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:context) { { current_user: user, ability: Ability.new(user) } }
  let(:mutation) { described_class.new(object: nil, context: context, field: nil) }
  
  describe '#resolve' do
    let(:valid_attributes) do
      {
        bio: 'Software developer with 5 years of experience',
        linkedin_url: 'https://linkedin.com/in/johndoe',
        github_url: 'https://github.com/johndoe',
        website_url: 'https://johndoe.dev',
        location: 'San Francisco, CA',
        company_name: 'Tech Corp',
        job_title: 'Senior Developer'
      }
    end
    
    before do
      profile # ensure profile exists
    end
    
    context 'with valid attributes' do
      it 'updates the profile successfully' do
        result = mutation.resolve(**valid_attributes)
        
        expect(result[:profile]).to eq(profile)
        expect(result[:errors]).to be_empty
        
        profile.reload
        expect(profile.bio).to eq('Software developer with 5 years of experience')
        expect(profile.linkedin_url).to eq('https://linkedin.com/in/johndoe')
        expect(profile.github_url).to eq('https://github.com/johndoe')
        expect(profile.website_url).to eq('https://johndoe.dev')
        expect(profile.location).to eq('San Francisco, CA')
        expect(profile.company_name).to eq('Tech Corp')
        expect(profile.job_title).to eq('Senior Developer')
      end
      
      it 'only updates provided attributes' do
        original_bio = profile.bio
        
        result = mutation.resolve(location: 'New York, NY')
        
        expect(result[:profile]).to eq(profile)
        expect(result[:errors]).to be_empty
        
        profile.reload
        expect(profile.location).to eq('New York, NY')
        expect(profile.bio).to eq(original_bio) # unchanged
      end
      
      it 'handles nil values by compacting them' do
        result = mutation.resolve(bio: 'New bio', linkedin_url: nil)
        
        expect(result[:profile]).to eq(profile)
        expect(result[:errors]).to be_empty
        
        profile.reload
        expect(profile.bio).to eq('New bio')
        # linkedin_url should remain unchanged due to compact
      end
    end
    
    context 'with invalid attributes' do
      before do
        allow(profile).to receive(:update).and_return(false)
        allow(profile).to receive_message_chain(:errors, :full_messages).and_return(['Bio is too long'])
      end
      
      it 'returns errors when update fails' do
        result = mutation.resolve(bio: 'x' * 1000)
        
        expect(result[:profile]).to be_nil
        expect(result[:errors]).to include('Bio is too long')
      end
    end
    
    context 'authentication and authorization' do
      context 'when user is not authenticated' do
        let(:context) { { current_user: nil } }
        
        it 'raises authentication error' do
          result = mutation.resolve(**valid_attributes)
          
          expect(result[:profile]).to be_nil
          expect(result[:errors]).to include('Authentication required.')
        end
      end
      
      context 'when user has no profile' do
        let(:user_without_profile) { create(:user) }
        let(:context) { { current_user: user_without_profile, ability: Ability.new(user_without_profile) } }
        
        it 'raises profile not found error' do
          result = mutation.resolve(**valid_attributes)
          
          expect(result[:profile]).to be_nil
          expect(result[:errors]).to include('Profile not found.')
        end
      end
      
      context 'when user cannot update profile' do
        before do
          ability = double('ability')
          allow(ability).to receive(:can?).with(:update, profile).and_return(false)
          allow(Ability).to receive(:new).with(user).and_return(ability)
        end
        
        it 'raises unauthorized error' do
          result = mutation.resolve(**valid_attributes)
          
          expect(result[:profile]).to be_nil
          expect(result[:errors]).to include('Unauthorized')
        end
      end
    end
    
    context 'error handling' do
      context 'when unexpected error occurs' do
        before do
          allow(profile).to receive(:update).and_raise(StandardError.new('Database connection error'))
          allow(Rails.logger).to receive(:error)
        end
        
        it 'catches and returns the error' do
          result = mutation.resolve(**valid_attributes)
          
          expect(result[:profile]).to be_nil
          expect(result[:errors]).to include('Database connection error')
        end
        
        it 'logs the error details' do
          mutation.resolve(**valid_attributes)
          
          expect(Rails.logger).to have_received(:error).with(/UpdateProfile error: StandardError - Database connection error/)
          expect(Rails.logger).to have_received(:error).with(kind_of(String)) # backtrace
        end
      end
      
      context 'when GraphQL execution error is raised' do
        before do
          allow(profile).to receive(:update).and_raise(GraphQL::ExecutionError.new('Custom GraphQL error'))
        end
        
        it 'catches GraphQL errors' do
          result = mutation.resolve(**valid_attributes)
          
          expect(result[:profile]).to be_nil
          expect(result[:errors]).to include('Custom GraphQL error')
        end
      end
    end
    
    describe 'field definitions' do
      it 'defines the correct arguments' do
        expect(described_class.arguments.keys).to include(
          'bio', 'linkedinUrl', 'githubUrl', 'websiteUrl', 
          'location', 'companyName', 'jobTitle'
        )
      end
      
      it 'defines the correct return fields' do
        expect(described_class.fields.keys).to include('profile', 'errors')
      end
      
      it 'has correct argument types' do
        expect(described_class.arguments['bio'].type.to_s).to include('String')
        expect(described_class.arguments['linkedinUrl'].type.to_s).to include('String')
      end
      
      it 'has correct field types' do
        expect(described_class.fields['profile'].type.to_s).to include('ProfileType')
        expect(described_class.fields['errors'].type.to_s).to include('[String!]')
      end
    end
    
    describe 'integration with Profile model' do
      it 'works with actual profile updates' do
        result = mutation.resolve(
          bio: 'Real bio update',
          location: 'Real location'
        )
        
        expect(result[:errors]).to be_empty
        expect(result[:profile]).to be_persisted
        expect(result[:profile].bio).to eq('Real bio update')
        expect(result[:profile].location).to eq('Real location')
      end
    end
  end
end