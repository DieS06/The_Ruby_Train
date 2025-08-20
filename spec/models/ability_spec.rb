# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  let(:user) { create(:user) }
  let(:super_admin) { create(:user).tap { |u| u.add_role(:super_admin) } }
  let(:admin) { create(:user).tap { |u| u.add_role(:admin) } }
  let(:academy) { create(:user).tap { |u| u.add_role(:academy) } }
  let(:mentor) { create(:user).tap { |u| u.add_role(:mentor) } }
  let(:student) { create(:user).tap { |u| u.add_role(:student) } }

  let(:content_unit) { create(:content_unit, state: 'visible') }
  let(:hidden_content_unit) { create(:content_unit, state: 'hidden') }

  describe 'anonymous user' do
    subject(:ability) { Ability.new(nil) }

    it 'can read visible content units' do
      expect(ability).to be_able_to(:read, content_unit)
    end

    it 'cannot read hidden content units' do
      expect(ability).not_to be_able_to(:read, hidden_content_unit)
    end

    it 'cannot manage anything else' do
      expect(ability).not_to be_able_to(:create, ContentUnit)
      expect(ability).not_to be_able_to(:update, content_unit)
      expect(ability).not_to be_able_to(:destroy, content_unit)
    end
  end

  describe 'authenticated user without roles' do
    subject(:ability) { Ability.new(user) }

    it 'can read visible content units' do
      expect(ability).to be_able_to(:read, content_unit)
    end

    it 'can read profile page' do
      expect(ability).to be_able_to(:read, :profile_page)
    end
  end

  describe 'super admin' do
    subject(:ability) { Ability.new(super_admin) }

    it 'can manage everything' do
      expect(ability).to be_able_to(:manage, :all)
      expect(ability).to be_able_to(:create, ContentUnit)
      expect(ability).to be_able_to(:update, content_unit)
      expect(ability).to be_able_to(:destroy, content_unit)
    end
  end

  describe 'admin' do
    subject(:ability) { Ability.new(admin) }

    it 'can invite users' do
      expect(ability).to be_able_to(:invite, User)
    end

    it 'can manage user roles' do
      expect(ability).to be_able_to(:assign_role, User)
      expect(ability).to be_able_to(:remove_role, User)
    end

    it 'can manage all core models' do
      expect(ability).to be_able_to(:manage, Topic)
      expect(ability).to be_able_to(:manage, ContentTopic)
      expect(ability).to be_able_to(:manage, Enrollment)
      expect(ability).to be_able_to(:manage, Group)
      expect(ability).to be_able_to(:manage, Evaluation)
      expect(ability).to be_able_to(:manage, Question)
      expect(ability).to be_able_to(:manage, AnswerOption)
      expect(ability).to be_able_to(:manage, Submission)
      expect(ability).to be_able_to(:manage, ContentUnit)
      expect(ability).to be_able_to(:manage, Badge)
      expect(ability).to be_able_to(:manage, UserBadge)
      expect(ability).to be_able_to(:manage, Progress)
    end

    it 'can read and update evaluation settings' do
      evaluation_setting = create(:evaluation_setting)
      expect(ability).to be_able_to(:read, evaluation_setting)
      expect(ability).to be_able_to(:update, evaluation_setting)
    end

    it 'can manage evaluation sections' do
      evaluation_section = create(:evaluation_section)
      expect(ability).to be_able_to(:read, evaluation_section)
      expect(ability).to be_able_to(:create, EvaluationSection)
      expect(ability).to be_able_to(:update, evaluation_section)
      expect(ability).to be_able_to(:destroy, evaluation_section)
    end

    it 'can archive evaluations and content units' do
      evaluation = create(:evaluation)
      expect(ability).to be_able_to(:archive, evaluation)
      expect(ability).to be_able_to(:archive, content_unit)
    end
  end

  describe 'academy' do
    subject(:ability) { Ability.new(academy) }

    it 'can invite users' do
      expect(ability).to be_able_to(:invite, User)
    end

    it 'can manage user roles' do
      expect(ability).to be_able_to(:assign_role, User)
      expect(ability).to be_able_to(:remove_role, User)
    end

    it 'can create groups' do
      expect(ability).to be_able_to(:create, Group)
    end

    it 'can manage own groups' do
      own_group = create(:group, created_by: academy.id)
      other_group = create(:group)

      expect(ability).to be_able_to(:read, own_group)
      expect(ability).to be_able_to(:update, own_group)
      expect(ability).not_to be_able_to(:update, other_group)
    end

    it 'can manage own enrollments' do
      own_enrollment = create(:enrollment, user_id: academy.id)
      other_enrollment = create(:enrollment)

      expect(ability).to be_able_to(:create, Enrollment)
      expect(ability).to be_able_to(:read, own_enrollment)
      expect(ability).to be_able_to(:update, own_enrollment)
      expect(ability).not_to be_able_to(:update, other_enrollment)
    end

    it 'can manage own evaluations' do
      own_evaluation = create(:evaluation, created_by: academy.id)
      other_evaluation = create(:evaluation)

      expect(ability).to be_able_to(:read, own_evaluation)
      expect(ability).to be_able_to(:create, Evaluation)
      expect(ability).to be_able_to(:update, own_evaluation)
      expect(ability).not_to be_able_to(:update, other_evaluation)
    end

    it 'can read visible badges' do
      visible_badge = create(:badge, state: 'visible')
      hidden_badge = create(:badge, state: 'hidden')

      expect(ability).to be_able_to(:read, visible_badge)
      expect(ability).not_to be_able_to(:read, hidden_badge)
    end
  end

  describe 'mentor' do
    subject(:ability) { Ability.new(mentor) }
    let(:group) { create(:group) }

    before do
      create(:group_membership, user: mentor, group: group, role_in_group: 'mentor')
    end

    it 'can invite users' do
      expect(ability).to be_able_to(:invite, User)
    end

    it 'can manage assigned groups' do
      expect(ability).to be_able_to(:manage, group)
    end

    it 'can manage own evaluations' do
      own_evaluation = create(:evaluation, created_by: mentor.id)
      other_evaluation = create(:evaluation)

      expect(ability).to be_able_to(:read, own_evaluation)
      expect(ability).to be_able_to(:create, Evaluation)
      expect(ability).to be_able_to(:update, own_evaluation)
      expect(ability).not_to be_able_to(:update, other_evaluation)
    end

    it 'can read visible badges' do
      visible_badge = create(:badge, state: 'visible')
      hidden_badge = create(:badge, state: 'hidden')

      expect(ability).to be_able_to(:read, visible_badge)
      expect(ability).not_to be_able_to(:read, hidden_badge)
    end
  end

  describe 'student' do
    subject(:ability) { Ability.new(student) }
    let(:group) { create(:group) }
    let(:enrollment) { create(:enrollment, user: student) }

    before do
      create(:group_membership, user: student, group: group, role_in_group: 'student')
    end

    it 'can read assigned groups' do
      expect(ability).to be_able_to(:read, group)
    end

    it 'can manage own enrollments' do
      own_enrollment = create(:enrollment, user_id: student.id)
      other_enrollment = create(:enrollment)

      expect(ability).to be_able_to(:create, Enrollment)
      expect(ability).to be_able_to(:read, own_enrollment)
      expect(ability).not_to be_able_to(:read, other_enrollment)
    end

    it 'can read own profile' do
      own_profile = create(:profile, user_id: student.id)
      other_profile = create(:profile)

      expect(ability).to be_able_to(:read, student)
      expect(ability).to be_able_to(:read, own_profile)
      expect(ability).not_to be_able_to(:read, other_profile)
    end

    it 'can read visible evaluations' do
      visible_evaluation = create(:evaluation, state: 'visible')
      hidden_evaluation = create(:evaluation, state: 'hidden')

      expect(ability).to be_able_to(:read, visible_evaluation)
      expect(ability).not_to be_able_to(:read, hidden_evaluation)
    end

    it 'can manage own submissions' do
      own_submission = create(:submission, user_id: student.id)
      other_submission = create(:submission)

      expect(ability).to be_able_to(:create, Submission)
      expect(ability).to be_able_to(:read, own_submission)
      expect(ability).not_to be_able_to(:read, other_submission)
    end

    it 'can read own submission answers' do
      own_submission = create(:submission, user_id: student.id)
      other_submission = create(:submission)

      own_answer = create(:submission_answer, submission: own_submission)
      other_answer = create(:submission_answer, submission: other_submission)

      expect(ability).to be_able_to(:read, own_answer)
      expect(ability).not_to be_able_to(:read, other_answer)
    end

    it 'can read visible badges and own user badges' do
      visible_badge = create(:badge, state: 'visible')
      hidden_badge = create(:badge, state: 'hidden')
      own_user_badge = create(:user_badge, user_id: student.id)
      other_user_badge = create(:user_badge)

      expect(ability).to be_able_to(:read, visible_badge)
      expect(ability).not_to be_able_to(:read, hidden_badge)
      expect(ability).to be_able_to(:read, own_user_badge)
      expect(ability).not_to be_able_to(:read, other_user_badge)
    end

    it 'can read own progress' do
      own_progress = create(:progress, user_id: student.id)
      other_progress = create(:progress)

      expect(ability).to be_able_to(:read, own_progress)
      expect(ability).not_to be_able_to(:read, other_progress)
    end
  end

  describe 'topic permissions' do
    let(:topic) { create(:topic, state: 'visible', created_by: user.id) }
    let(:hidden_topic) { create(:topic, state: 'hidden') }

    context 'when user is admin' do
      subject(:ability) { Ability.new(admin) }

      it 'can manage own topics' do
        own_topic = create(:topic, created_by: admin.id)
        expect(ability).to be_able_to(:create, Topic)
        expect(ability).to be_able_to(:update, own_topic)
        expect(ability).to be_able_to(:destroy, own_topic)
      end
    end

    context 'when user is student' do
      subject(:ability) { Ability.new(student) }

      it 'can only read visible topics' do
        expect(ability).to be_able_to(:read, topic)
        expect(ability).not_to be_able_to(:read, hidden_topic)
        expect(ability).not_to be_able_to(:create, Topic)
      end
    end
  end

  describe 'content topic permissions' do
    let(:content_topic) { create(:content_topic, state: 'visible') }

    context 'when user is admin' do
      subject(:ability) { Ability.new(admin) }

      it 'can manage content topics for own content units' do
        content_unit = create(:content_unit, created_by: admin.id)
        own_content_topic = create(:content_topic, content_unit: content_unit)

        expect(ability).to be_able_to(:create, ContentTopic)
        expect(ability).to be_able_to(:update, own_content_topic)
        expect(ability).to be_able_to(:destroy, own_content_topic)
      end
    end

    context 'when user is student' do
      subject(:ability) { Ability.new(student) }

      it 'can only read visible content topics' do
        expect(ability).to be_able_to(:read, content_topic)
        expect(ability).not_to be_able_to(:create, ContentTopic)
      end
    end
  end

  describe 'has_access_to_course? helper method' do
    let(:group) { create(:group) }
    let(:course) { create(:content_unit) }
    let(:group_course) { create(:group_course, group: group, content_unit: course) }

    before do
      create(:group_membership, user: user, group: group)
      group_course
    end

    it 'returns true when user has access to course through group' do
      ability = Ability.new(user)
      expect(ability.has_access_to_course?(course.id)).to be true
    end

    it 'returns false when user does not have access to course' do
      other_course = create(:content_unit)
      ability = Ability.new(user)
      expect(ability.has_access_to_course?(other_course.id)).to be false
    end
  end
end
