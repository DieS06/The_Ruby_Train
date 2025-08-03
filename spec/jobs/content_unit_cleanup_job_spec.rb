# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentUnitCleanupJob, type: :job do
  describe '#perform' do
    let!(:recent_deleted_unit) { create(:content_unit, state: 'deleted', deleted_at: 15.days.ago) }
    let!(:old_deleted_unit) { create(:content_unit, state: 'deleted', deleted_at: 45.days.ago) }
    let!(:very_old_deleted_unit) { create(:content_unit, state: 'deleted', deleted_at: 60.days.ago) }
    let!(:visible_unit) { create(:content_unit, state: 'visible', deleted_at: 45.days.ago) }
    let!(:archived_unit) { create(:content_unit, state: 'archived', deleted_at: 45.days.ago) }
    
    it 'destroys content units deleted more than 31 days ago' do
      expect {
        described_class.perform_now
      }.to change { ContentUnit.where(id: [old_deleted_unit.id, very_old_deleted_unit.id]).count }.from(2).to(0)
    end
    
    it 'preserves recently deleted content units (within 31 days)' do
      described_class.perform_now
      
      expect(ContentUnit.find_by(id: recent_deleted_unit.id)).to be_present
    end
    
    it 'preserves content units that are not deleted' do
      described_class.perform_now
      
      expect(ContentUnit.find_by(id: visible_unit.id)).to be_present
      expect(ContentUnit.find_by(id: archived_unit.id)).to be_present
    end
    
    it 'only considers deleted state content units' do
      scope_double = double('deleted_scope')
      
      allow(ContentUnit).to receive(:where).with(state: :deleted).and_return(scope_double)
      allow(scope_double).to receive(:where).with("deleted_at <= ?", kind_of(Time)).and_return([])
      allow([]).to receive(:find_each)
      
      described_class.perform_now
      
      expect(ContentUnit).to have_received(:where).with(state: :deleted)
    end
    
    it 'uses the correct threshold (31 days ago)' do
      freeze_time do
        threshold = 31.days.ago
        scope_double = double('deleted_scope')
        
        allow(ContentUnit).to receive(:where).with(state: :deleted).and_return(scope_double)
        allow(scope_double).to receive(:where).with("deleted_at <= ?", threshold).and_return([])
        allow([]).to receive(:find_each)
        
        described_class.perform_now
        
        expect(scope_double).to have_received(:where).with("deleted_at <= ?", threshold)
      end
    end
    
    it 'processes content units in batches using find_each' do
      units_relation = ContentUnit.where(state: :deleted).where("deleted_at <= ?", 31.days.ago)
      allow(ContentUnit).to receive(:where).with(state: :deleted).and_return(units_relation)
      allow(units_relation).to receive(:where).and_return([old_deleted_unit, very_old_deleted_unit])
      
      expect([old_deleted_unit, very_old_deleted_unit]).to receive(:find_each).and_yield(old_deleted_unit).and_yield(very_old_deleted_unit)
      
      described_class.perform_now
    end
    
    it 'calls really_destroy! on each eligible content unit' do
      allow(old_deleted_unit).to receive(:really_destroy!)
      allow(very_old_deleted_unit).to receive(:really_destroy!)
      
      # Mock the query chain
      relation = double('relation')
      allow(ContentUnit).to receive(:where).with(state: :deleted).and_return(relation)
      allow(relation).to receive(:where).and_return([old_deleted_unit, very_old_deleted_unit])
      allow([old_deleted_unit, very_old_deleted_unit]).to receive(:find_each).and_yield(old_deleted_unit).and_yield(very_old_deleted_unit)
      
      described_class.perform_now
      
      expect(old_deleted_unit).to have_received(:really_destroy!)
      expect(very_old_deleted_unit).to have_received(:really_destroy!)
    end
    
    context 'when no deleted content units exist' do
      before do
        ContentUnit.where(state: 'deleted').destroy_all
      end
      
      it 'completes without errors' do
        expect { described_class.perform_now }.not_to raise_error
      end
    end
    
    context 'when destruction fails' do
      before do
        allow(old_deleted_unit).to receive(:really_destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
        
        # Mock the query to return only the problematic unit
        relation = double('relation')
        allow(ContentUnit).to receive(:where).with(state: :deleted).and_return(relation)
        allow(relation).to receive(:where).and_return([old_deleted_unit])
        allow([old_deleted_unit]).to receive(:find_each).and_yield(old_deleted_unit)
      end
      
      it 'raises the exception' do
        expect {
          described_class.perform_now
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
    
    describe 'edge cases' do
      it 'handles content units deleted exactly 31 days ago' do
        exactly_31_days_unit = create(:content_unit, state: 'deleted', deleted_at: 31.days.ago)
        
        described_class.perform_now
        
        # Unit deleted exactly 31 days ago should be preserved
        expect(ContentUnit.find_by(id: exactly_31_days_unit.id)).to be_present
      end
      
      it 'handles content units deleted just over 31 days ago' do
        just_over_31_days_unit = create(:content_unit, state: 'deleted', deleted_at: 31.days.ago - 1.minute)
        
        expect {
          described_class.perform_now
        }.to change { ContentUnit.exists?(just_over_31_days_unit.id) }.from(true).to(false)
      end
    end
    
    describe 'with hierarchical content units' do
      let!(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', state: 'deleted', deleted_at: 45.days.ago) }
      let!(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', parent: course, state: 'deleted', deleted_at: 45.days.ago) }
      let!(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', parent: module_unit, state: 'deleted', deleted_at: 45.days.ago) }
      
      it 'cleans up all types of content units' do
        expect {
          described_class.perform_now
        }.to change { ContentUnit.where(id: [course.id, module_unit.id, lesson.id]).count }.from(3).to(0)
      end
    end
  end
  
  describe 'job configuration' do
    it 'is queued on default queue' do
      expect(described_class.queue_name).to eq('default')
    end
    
    it 'inherits from ApplicationJob' do
      expect(described_class.superclass).to eq(ApplicationJob)
    end
  end
  
  describe 'integration test' do
    let!(:units_to_cleanup) do
      [
        create(:content_unit, state: 'deleted', deleted_at: 35.days.ago),
        create(:content_unit, state: 'deleted', deleted_at: 50.days.ago)
      ]
    end
    
    let!(:units_to_keep) do
      [
        create(:content_unit, state: 'deleted', deleted_at: 20.days.ago),
        create(:content_unit, state: 'visible', deleted_at: 50.days.ago)
      ]
    end
    
    it 'performs the cleanup operation correctly' do
      initial_count = ContentUnit.count
      
      described_class.perform_now
      
      expect(ContentUnit.count).to eq(initial_count - 2)
      
      units_to_cleanup.each do |unit|
        expect(ContentUnit.exists?(unit.id)).to be false
      end
      
      units_to_keep.each do |unit|
        expect(ContentUnit.exists?(unit.id)).to be true
      end
    end
  end
end
