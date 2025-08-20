# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::User::MyProfile, type: :graphql do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  let(:context) { { current_user: user, ability: Ability.new(user) } }
  let(:query) { described_class.new(object: nil, context: context, field: nil) }

  describe '#resolve' do
    context 'when user has a profile' do
      before { profile }

      it 'returns the current user profile' do
        result = query.resolve

        expect(result).to eq(profile)
      end

      it 'returns profile with correct attributes' do
        profile.update!(
          bio: 'Software developer',
          linkedin_url: 'https://linkedin.com/in/johndoe',
          location: 'San Francisco'
        )

        result = query.resolve

        expect(result.bio).to eq('Software developer')
        expect(result.linkedin_url).to eq('https://linkedin.com/in/johndoe')
        expect(result.location).to eq('San Francisco')
        expect(result.user).to eq(user)
      end
    end

    context 'when user has no profile' do
      it 'returns nil' do
        result = query.resolve

        expect(result).to be_nil
      end
    end

    context 'when current_user is nil' do
      let(:context) { { current_user: nil } }

      it 'raises an error' do
        expect {
          query.resolve
        }.to raise_error(NoMethodError)
      end
    end

    context 'with different users' do
      let(:other_user) { create(:user) }
      let(:other_profile) { create(:profile, user: other_user) }

      before do
        profile
        other_profile
      end

      it 'returns only the current user profile' do
        result = query.resolve

        expect(result).to eq(profile)
        expect(result).not_to eq(other_profile)
      end
    end
  end

  describe 'query definition' do
    it 'has correct description' do
      expect(described_class.description).to eq("Returns the current user's profile")
    end

    it 'returns ProfileType' do
      expect(described_class.type.to_s).to include('ProfileType')
    end

    it 'allows null return' do
      expect(described_class.type.non_null?).to be false
    end

    it 'has no arguments' do
      expect(described_class.arguments).to be_empty
    end
  end

  describe 'integration with GraphQL schema' do
    let(:query_string) do
      <<~GRAPHQL
        query {
          myProfile {
            id
            bio
            user {
              email
            }
          }
        }
      GRAPHQL
    end

    context 'when executed through schema' do
      before { profile }

      it 'returns profile data' do
        result = TheRubyTrainSchema.execute(
          query_string,
          context: context
        )

        expect(result.dig('data', 'myProfile')).to be_present
        expect(result.dig('data', 'myProfile', 'id')).to eq(profile.id.to_s)
        expect(result.dig('data', 'myProfile', 'user', 'email')).to eq(user.email)
      end
    end

    context 'when user has no profile' do
      it 'returns null' do
        result = TheRubyTrainSchema.execute(
          query_string,
          context: context
        )

        expect(result.dig('data', 'myProfile')).to be_nil
      end
    end

    context 'when not authenticated' do
      let(:context) { { current_user: nil } }

      it 'returns error' do
        result = TheRubyTrainSchema.execute(
          query_string,
          context: context
        )

        expect(result['errors']).to be_present
      end
    end
  end

  describe 'association loading' do
    before { profile }

    it 'can access user association' do
      result = query.resolve

      expect(result.user).to eq(user)
      expect(result.user.email).to eq(user.email)
    end

    it 'loads profile attributes correctly' do
      profile.update!(
        bio: 'Test bio',
        github_url: 'https://github.com/test'
      )

      result = query.resolve

      expect(result.bio).to eq('Test bio')
      expect(result.github_url).to eq('https://github.com/test')
    end
  end

  describe 'performance considerations' do
    it 'does not execute additional queries when profile exists' do
      profile # create profile

      expect {
        query.resolve
      }.not_to exceed_query_limit(1)
    end
  end

  describe 'error scenarios' do
    context 'when database error occurs' do
      before do
        allow(user).to receive(:profile).and_raise(ActiveRecord::ConnectionTimeoutError)
      end

      it 'propagates database errors' do
        expect {
          query.resolve
        }.to raise_error(ActiveRecord::ConnectionTimeoutError)
      end
    end

    context 'when user model is corrupted' do
      before do
        allow(user).to receive(:profile).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'propagates model errors' do
        expect {
          query.resolve
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
