# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionMailer, type: :mailer do
  describe '#results_email' do
    let(:user) { create(:user, email: 'student@example.com') }
    let(:evaluation) { create(:evaluation, title: 'Ruby Basics Quiz') }
    let(:submission) { create(:submission, user: user, evaluation: evaluation, score: 85, graded: true) }
    let(:mail) { described_class.results_email(submission) }
    
    it 'renders the headers' do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['notificaciones@equixdigital.com'])
      expect(mail.subject).to eq('Results of your evaluation Ruby Basics Quiz')
    end
    
    it 'includes the user information in the email body' do
      expect(mail.body.encoded).to include(user.email)
    end
    
    it 'includes the evaluation title in the email body' do
      expect(mail.body.encoded).to include(evaluation.title)
    end
    
    it 'includes the submission score in the email body' do
      expect(mail.body.encoded).to include('85')
    end
    
    it 'sets the correct instance variables' do
      mail.body # trigger the mail generation
      
      mailer_instance = mail.instance_variable_get(:@mail)
      expect(mailer_instance.instance_variable_get(:@submission)).to eq(submission)
      expect(mailer_instance.instance_variable_get(:@user)).to eq(user)
      expect(mailer_instance.instance_variable_get(:@evaluation)).to eq(evaluation)
    end
    
    describe 'subject line' do
      context 'with different evaluation titles' do
        let(:evaluation) { create(:evaluation, title: 'Advanced JavaScript') }
        
        it 'includes the evaluation title in subject' do
          expect(mail.subject).to eq('Results of your evaluation Advanced JavaScript')
        end
      end
      
      context 'with special characters in title' do
        let(:evaluation) { create(:evaluation, title: 'C++ & Algorithms') }
        
        it 'handles special characters in subject' do
          expect(mail.subject).to eq('Results of your evaluation C++ & Algorithms')
        end
      end
    end
    
    describe 'email content' do
      context 'with high score' do
        let(:submission) { create(:submission, user: user, evaluation: evaluation, score: 95) }
        
        it 'includes the high score' do
          expect(mail.body.encoded).to include('95')
        end
      end
      
      context 'with low score' do
        let(:submission) { create(:submission, user: user, evaluation: evaluation, score: 45) }
        
        it 'includes the low score' do
          expect(mail.body.encoded).to include('45')
        end
      end
      
      context 'with zero score' do
        let(:submission) { create(:submission, user: user, evaluation: evaluation, score: 0) }
        
        it 'includes zero score' do
          expect(mail.body.encoded).to include('0')
        end
      end
    end
    
    describe 'mailer configuration' do
      it 'uses the correct default from address' do
        expect(described_class.default[:from]).to eq('notificaciones@equixdigital.com')
      end
      
      it 'inherits from ApplicationMailer' do
        expect(described_class.superclass).to eq(ApplicationMailer)
      end
    end
    
    describe 'error handling' do
      context 'when submission has no user' do
        let(:submission) { build(:submission, user: nil, evaluation: evaluation) }
        
        it 'raises an error' do
          expect { mail }.to raise_error(NoMethodError)
        end
      end
      
      context 'when submission has no evaluation' do
        let(:submission) { build(:submission, user: user, evaluation: nil) }
        
        it 'raises an error' do
          expect { mail }.to raise_error(NoMethodError)
        end
      end
    end
    
    describe 'delivery' do
      it 'can be delivered' do
        expect { mail.deliver_now }.not_to raise_error
      end
      
      it 'can be delivered later' do
        expect { mail.deliver_later }.not_to raise_error
      end
    end
  end
end
