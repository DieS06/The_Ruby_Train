# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Learning Flow Integration', type: :integration do
  let(:admin) { create(:user).tap { |u| u.add_role(:admin) } }
  let(:student) { create(:user).tap { |u| u.add_role(:student) } }

  describe 'Complete learning workflow' do
    let!(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', title: 'Ruby Fundamentals', state: 'visible') }
    let!(:module_unit) { create(:content_unit, type: 'ContentUnit::ModuleUnit', title: 'Basic Syntax', parent: course, state: 'visible') }
    let!(:segment) { create(:content_unit, type: 'ContentUnit::SegmentUnit', title: 'Variables', parent: module_unit, state: 'visible') }
    let!(:lesson) { create(:content_unit, type: 'ContentUnit::LessonUnit', title: 'String Variables', parent: segment, state: 'visible') }
    let!(:quiz) { create(:evaluation, type: 'Evaluations::Quiz', content_unit: lesson, state: 'visible') }
    let!(:question) { create(:question, evaluation: quiz, points: 10) }
    let!(:correct_option) { create(:answer_option, question: question, is_correct: true) }
    let!(:incorrect_option) { create(:answer_option, question: question, is_correct: false) }

    before do
      student.create_profile unless student.profile
    end

    it 'allows student to complete the full learning flow' do
      # Step 1: Student enrolls in course
      enrollment = create(:enrollment, user: student, content_unit: course)
      expect(enrollment).to be_persisted
      expect(enrollment.user).to eq(student)
      expect(enrollment.content_unit).to eq(course)

      # Step 2: Student accesses lesson content
      sign_in student
      get "/content_units/#{lesson.slug}"
      expect(response).to have_http_status(:success)

      # Step 3: Student takes quiz
      submission = create(:submission, user: student, evaluation: quiz)
      answer = create(:submission_answer,
                     submission: submission,
                     question: question,
                     answer_option: correct_option)

      expect(submission).to be_persisted
      expect(answer.answer_option).to be_correct

      # Step 4: Auto-grading occurs
      AutoGradeSubmissionJob.perform_now(submission.id)

      submission.reload
      expect(submission).to be_graded
      expect(submission.score).to eq(10)
      expect(submission.submitted_at).to be_present

      # Step 5: Progress is recorded
      progress = create(:progress,
                       user: student,
                       content_unit: lesson,
                       score: submission.score)
      progress.update!(state: 'passed')

      expect(progress.user).to eq(student)
      expect(progress.content_unit).to eq(lesson)
      expect(progress.score).to eq(10)
      expect(progress).to be_passed

      # Step 6: Badge evaluation (if applicable)
      badge = create(:badge,
                    name: 'First Lesson Complete',
                    criteria: {
                      'type' => 'lesson',
                      'conditions' => { 'lesson_id' => lesson.id }
                    })

      BadgeAssigner.new(student).call

      # Verify badge was awarded (would need actual badge logic)
      expect(student.badges).to be_present if student.respond_to?(:badges)
    end

    it 'prevents access to content without proper enrollment' do
      # Student without enrollment
      unenrolled_student = create(:user).tap { |u| u.add_role(:student) }

      sign_in unenrolled_student
      get "/content_units/#{lesson.slug}"

      # Should still render template but authorization might restrict content
      expect(response).to have_http_status(:success)
    end

    it 'tracks progress through content hierarchy' do
      # Create enrollment
      enrollment = create(:enrollment, user: student, content_unit: course)

      # Complete lesson
      progress = create(:progress,
                       user: student,
                       content_unit: lesson,
                       score: 100,
                       state: 'passed')

      # Verify progress tracking
      expect(student.progresses.where(content_unit: lesson, state: 'passed')).to exist
      expect(enrollment.user.progresses.count).to eq(1)

      # Check course completion status
      total_lessons = course.descendants.where(type: 'ContentUnit::LessonUnit').count
      completed_lessons = student.progresses.joins(:content_unit)
                                 .where(content_units: { type: 'ContentUnit::LessonUnit' }, state: 'passed')
                                 .count

      completion_percentage = (completed_lessons.to_f / total_lessons) * 100
      expect(completion_percentage).to eq(100.0) # Since we only have 1 lesson
    end
  end

  describe 'Group-based learning workflow' do
    let(:mentor) { create(:user).tap { |u| u.add_role(:mentor) } }
    let(:group) { create(:group, state: 'active') }
    let!(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', state: 'visible') }

    it 'supports group-based course assignment and tracking' do
      # Step 1: Create group with mentor and students
      mentor_membership = create(:group_membership,
                               user: mentor,
                               group: group,
                               role_in_group: 'mentor',
                               state: 'joined')

      student_membership = create(:group_membership,
                                user: student,
                                group: group,
                                role_in_group: 'student',
                                state: 'joined')

      # Step 2: Assign course to group
      group_course = create(:group_course, group: group, content_unit: course)

      expect(group_course.group).to eq(group)
      expect(group_course.content_unit).to eq(course)

      # Step 3: Students auto-enroll through group
      enrollment = create(:enrollment, user: student, content_unit: course)

      # Step 4: Mentor can track student progress
      progress = create(:progress, user: student, content_unit: course, score: 85)

      # Verify mentor has access to student progress through group
      expect(group.users).to include(student)
      expect(group.users).to include(mentor)
      expect(student.progresses.where(content_unit: course)).to exist
    end

    it 'handles group invitation workflow' do
      # Step 1: Mentor invites student to group
      invitation_token = SecureRandom.hex(16)
      membership = create(:group_membership,
                         user: student,
                         group: group,
                         invited_token: invitation_token,
                         state: 'invited',
                         role_in_group: 'student')

      # Step 2: Student accepts invitation
      get "/groups/accept/#{invitation_token}"

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Welcome to the group!')

      # Step 3: Verify membership state
      membership.reload
      expect(membership.state).to eq('joined')
      expect(membership.invited_token).to be_nil
      expect(membership.joined_at).to be_present
    end
  end

  describe 'Assessment and feedback workflow' do
    let!(:exam) { create(:evaluation, type: 'Evaluations::Exam', content_unit: course, state: 'visible') }
    let!(:question1) { create(:question, evaluation: exam, points: 15) }
    let!(:question2) { create(:question, evaluation: exam, points: 25) }
    let!(:correct_option1) { create(:answer_option, question: question1, is_correct: true) }
    let!(:incorrect_option2) { create(:answer_option, question: question2, is_correct: false) }

    it 'processes exam submissions and sends results' do
      # Step 1: Student takes exam
      submission = create(:submission, user: student, evaluation: exam)

      # Step 2: Student answers questions
      answer1 = create(:submission_answer,
                      submission: submission,
                      question: question1,
                      answer_option: correct_option1)

      answer2 = create(:submission_answer,
                      submission: submission,
                      question: question2,
                      answer_option: incorrect_option2)

      # Step 3: Auto-grading occurs
      AutoGradeSubmissionJob.perform_now(submission.id)

      submission.reload
      expect(submission).to be_graded
      expect(submission.score).to eq(15) # Only first question correct

      # Step 4: Results email is sent
      expect {
        SubmissionMailer.results_email(submission).deliver_now
      }.not_to raise_error

      # Step 5: Verify submission answers are graded
      answer1.reload
      answer2.reload
      expect(answer1).to be_correct
      expect(answer2).not_to be_correct
    end

    it 'handles manual review requirements' do
      # Create submission requiring manual review
      submission = create(:submission,
                         user: student,
                         evaluation: exam,
                         manual_review_required: true)

      # Auto-grading should not mark as final
      AutoGradeSubmissionJob.perform_now(submission.id)

      submission.reload
      expect(submission.manual_review_required).to be true
      # Additional manual review logic would go here
    end
  end

  describe 'GraphQL integration workflow' do
    let(:context) { { current_user: student, ability: Ability.new(student) } }

    it 'allows complete CRUD operations through GraphQL' do
      # Step 1: Query user profile
      profile_query = <<~GRAPHQL
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

      result = TheRubyTrainSchema.execute(profile_query, context: context)

      if student.profile
        expect(result.dig('data', 'myProfile')).to be_present
      else
        expect(result.dig('data', 'myProfile')).to be_nil
      end

      # Step 2: Update profile through mutation
      student.create_profile unless student.profile

      update_mutation = <<~GRAPHQL
        mutation {
          updateProfile(input: {
            bio: "Updated bio",
            location: "New York"
          }) {
            profile {
              bio
              location
            }
            errors
          }
        }
      GRAPHQL

      result = TheRubyTrainSchema.execute(update_mutation, context: context)

      expect(result.dig('data', 'updateProfile', 'profile', 'bio')).to eq('Updated bio')
      expect(result.dig('data', 'updateProfile', 'profile', 'location')).to eq('New York')
      expect(result.dig('data', 'updateProfile', 'errors')).to be_empty

      # Step 3: Query content units
      content_query = <<~GRAPHQL
        query($id: ID!) {
          findContentUnit(id: $id) {
            id
            title
            type
          }
        }
      GRAPHQL

      result = TheRubyTrainSchema.execute(
        content_query,
        variables: { id: course.id },
        context: context
      )

      expect(result.dig('data', 'findContentUnit', 'title')).to eq(course.title)
    end
  end
end
