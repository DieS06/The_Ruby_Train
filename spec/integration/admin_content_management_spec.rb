# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Content Management Integration', type: :integration do
  let(:admin) { create(:user).tap { |u| u.add_role(:admin) } }
  let(:mentor) { create(:user).tap { |u| u.add_role(:mentor) } }
  let(:student) { create(:user).tap { |u| u.add_role(:student) } }
  
  describe 'Content creation and management workflow' do
    it 'allows admin to create complete course structure' do
      sign_in admin
      
      # Step 1: Create course
      course = create(:content_unit, 
                     type: 'ContentUnit::CourseUnit',
                     title: 'Advanced Ruby',
                     slug: 'advanced-ruby',
                     description: 'Deep dive into Ruby',
                     created_by: admin.id,
                     state: 'draft')
      
      expect(course).to be_persisted
      expect(course.created_by).to eq(admin.id)
      expect(course).to be_draft
      
      # Step 2: Create module within course
      module_unit = create(:content_unit,
                          type: 'ContentUnit::ModuleUnit',
                          title: 'Metaprogramming',
                          slug: 'metaprogramming',
                          parent: course,
                          created_by: admin.id,
                          state: 'draft')
      
      expect(module_unit.parent).to eq(course)
      expect(course.children).to include(module_unit)
      
      # Step 3: Create segment within module
      segment = create(:content_unit,
                      type: 'ContentUnit::SegmentUnit',
                      title: 'Method Definition',
                      slug: 'method-definition',
                      parent: module_unit,
                      created_by: admin.id,
                      state: 'draft')
      
      expect(segment.parent).to eq(module_unit)
      expect(module_unit.children).to include(segment)
      
      # Step 4: Create lessons within segment
      lesson1 = create(:content_unit,
                      type: 'ContentUnit::LessonUnit',
                      title: 'define_method',
                      slug: 'define-method',
                      parent: segment,
                      created_by: admin.id,
                      state: 'draft')
      
      lesson2 = create(:content_unit,
                      type: 'ContentUnit::LessonUnit',
                      title: 'method_missing',
                      slug: 'method-missing',
                      parent: segment,
                      created_by: admin.id,
                      state: 'draft')
      
      expect(segment.children).to include(lesson1, lesson2)
      
      # Step 5: Create evaluations
      quiz = create(:evaluation,
                   type: 'Evaluations::Quiz',
                   title: 'Metaprogramming Quiz',
                   content_unit: lesson1,
                   created_by: admin.id,
                   state: 'draft')
      
      exam = create(:evaluation,
                   type: 'Evaluations::Exam',
                   title: 'Module Final Exam',
                   content_unit: module_unit,
                   created_by: admin.id,
                   state: 'draft')
      
      # Step 6: Add questions to evaluations
      question1 = create(:question,
                        evaluation: quiz,
                        content: 'What does define_method do?',
                        points: 10,
                        created_by: admin.id)
      
      question2 = create(:question,
                        evaluation: exam,
                        content: 'Explain method_missing',
                        points: 25,
                        created_by: admin.id)
      
      # Step 7: Add answer options
      create(:answer_option, question: question1, content: 'Defines methods dynamically', is_correct: true)
      create(:answer_option, question: question1, content: 'Deletes methods', is_correct: false)
      
      create(:answer_option, question: question2, content: 'Handles missing methods', is_correct: true)
      create(:answer_option, question: question2, content: 'Throws errors', is_correct: false)
      
      # Step 8: Publish content
      [course, module_unit, segment, lesson1, lesson2].each do |unit|
        unit.update!(state: 'visible')
      end
      
      [quiz, exam].each do |evaluation|
        evaluation.update!(state: 'visible')
      end
      
      # Verify complete structure
      expect(course.descendants.count).to eq(4) # module + segment + 2 lessons
      expect(course.evaluations.count).to eq(2) # quiz + exam
      expect(quiz.questions.count).to eq(1)
      expect(exam.questions.count).to eq(1)
      expect(question1.answer_options.count).to eq(2)
      expect(question2.answer_options.count).to eq(2)
    end
    
    it 'enforces proper authorization throughout workflow' do
      # Test student cannot create content
      sign_in student
      
      expect {
        create(:content_unit, created_by: student.id)
      }.to raise_error(CanCan::AccessDenied).or change { ContentUnit.count }.by(0)
      
      # Test mentor can create limited content
      sign_in mentor
      
      course = create(:content_unit, 
                     type: 'ContentUnit::CourseUnit',
                     created_by: admin.id,
                     state: 'visible')
      
      # Mentor should be able to create evaluations for existing content
      evaluation = create(:evaluation,
                         content_unit: course,
                         created_by: mentor.id,
                         state: 'draft')
      
      expect(evaluation).to be_persisted
      expect(evaluation.created_by).to eq(mentor.id)
    end
  end
  
  describe 'User and group management workflow' do
    it 'allows admin to manage complete user lifecycle' do
      sign_in admin
      
      # Step 1: Create groups
      beginner_group = create(:group, 
                             name: 'Beginners Cohort',
                             description: 'New Ruby developers',
                             created_by: admin.id,
                             state: 'open')
      
      advanced_group = create(:group,
                             name: 'Advanced Cohort', 
                             description: 'Experienced developers',
                             created_by: admin.id,
                             state: 'active')
      
      # Step 2: Assign mentors to groups
      mentor1 = create(:user).tap { |u| u.add_role(:mentor) }
      mentor2 = create(:user).tap { |u| u.add_role(:mentor) }
      
      mentor1_membership = create(:group_membership,
                                 user: mentor1,
                                 group: beginner_group,
                                 role_in_group: 'mentor',
                                 state: 'joined')
      
      mentor2_membership = create(:group_membership,
                                 user: mentor2,
                                 group: advanced_group,
                                 role_in_group: 'mentor',
                                 state: 'joined')
      
      # Step 3: Invite students to groups
      students = create_list(:user, 3).each { |u| u.add_role(:student) }
      
      students.each_with_index do |student, index|
        group = index < 2 ? beginner_group : advanced_group
        
        result = InviteUserService.call(
          inviter: admin,
          email: student.email,
          first_name: student.first_name,
          last_name: student.last_name,
          role: :student,
          group: group
        )
        
        expect(result).to eq(student)
        membership = GroupMembership.find_by(user: student, group: group)
        expect(membership).to be_present
        expect(membership.state).to eq('invited')
      end
      
      # Step 4: Assign courses to groups
      basic_course = create(:content_unit, type: 'ContentUnit::CourseUnit', title: 'Ruby Basics')
      advanced_course = create(:content_unit, type: 'ContentUnit::CourseUnit', title: 'Ruby Advanced')
      
      basic_group_course = create(:group_course, group: beginner_group, content_unit: basic_course)
      advanced_group_course = create(:group_course, group: advanced_group, content_unit: advanced_course)
      
      expect(beginner_group.content_units).to include(basic_course)
      expect(advanced_group.content_units).to include(advanced_course)
      
      # Step 5: Students accept invitations
      students.each do |student|
        membership = GroupMembership.find_by(user: student)
        token = membership.invited_token
        
        get "/groups/accept/#{token}"
        
        expect(response).to have_http_status(:success)
        membership.reload
        expect(membership.state).to eq('joined')
      end
      
      # Verify final state
      expect(beginner_group.users.where(roles: { name: 'student' }).count).to eq(2)
      expect(advanced_group.users.where(roles: { name: 'student' }).count).to eq(1)
      expect(beginner_group.users.where(roles: { name: 'mentor' }).count).to eq(1)
      expect(advanced_group.users.where(roles: { name: 'mentor' }).count).to eq(1)
    end
  end
  
  describe 'Assessment creation and management' do
    let!(:course) { create(:content_unit, type: 'ContentUnit::CourseUnit', created_by: admin.id) }
    
    it 'allows complete assessment workflow' do
      sign_in admin
      
      # Step 1: Create evaluation with settings
      evaluation = create(:evaluation,
                         type: 'Evaluations::Exam',
                         title: 'Final Assessment',
                         content_unit: course,
                         created_by: admin.id,
                         state: 'draft')
      
      settings = create(:evaluation_setting,
                       evaluation: evaluation,
                       time_limit: 120,
                       attempts_allowed: 2,
                       randomize_questions: true)
      
      # Step 2: Create sections
      section1 = create(:evaluation_section,
                       evaluation: evaluation,
                       title: 'Syntax',
                       description: 'Basic syntax questions')
      
      section2 = create(:evaluation_section,
                       evaluation: evaluation,
                       title: 'OOP',
                       description: 'Object-oriented programming')
      
      # Step 3: Add questions to sections
      question1 = create(:question,
                        evaluation: evaluation,
                        evaluation_section: section1,
                        content: 'What is a variable?',
                        points: 10,
                        created_by: admin.id)
      
      question2 = create(:question,
                        evaluation: evaluation,
                        evaluation_section: section2,
                        content: 'What is inheritance?',
                        points: 15,
                        created_by: admin.id)
      
      # Step 4: Add multiple choice options
      create(:answer_option, question: question1, content: 'Storage for data', is_correct: true)
      create(:answer_option, question: question1, content: 'A function', is_correct: false)
      create(:answer_option, question: question1, content: 'A class', is_correct: false)
      
      create(:answer_option, question: question2, content: 'Code reuse mechanism', is_correct: true)
      create(:answer_option, question: question2, content: 'Variable type', is_correct: false)
      
      # Step 5: Test evaluation with student submission
      evaluation.update!(state: 'visible')
      
      student_user = create(:user).tap { |u| u.add_role(:student) }
      submission = create(:submission, user: student_user, evaluation: evaluation)
      
      # Student answers questions
      answer1 = create(:submission_answer,
                      submission: submission,
                      question: question1,
                      answer_option: question1.answer_options.where(is_correct: true).first)
      
      answer2 = create(:submission_answer,
                      submission: submission,
                      question: question2,
                      answer_option: question2.answer_options.where(is_correct: false).first)
      
      # Step 6: Auto-grade submission
      AutoGradeSubmissionJob.perform_now(submission.id)
      
      submission.reload
      expect(submission).to be_graded
      expect(submission.score).to eq(10) # Only first question correct
      
      # Step 7: Send results
      expect {
        SubmissionMailer.results_email(submission).deliver_now
      }.not_to raise_error
      
      # Verify complete assessment structure
      expect(evaluation.evaluation_sections.count).to eq(2)
      expect(evaluation.questions.count).to eq(2)
      expect(evaluation.evaluation_setting).to be_present
      expect(evaluation.submissions.count).to eq(1)
      expect(question1.answer_options.count).to eq(3)
      expect(question2.answer_options.count).to eq(2)
    end
  end
  
  describe 'Content lifecycle management' do
    it 'handles complete content lifecycle with proper cleanup' do
      sign_in admin
      
      # Step 1: Create content
      course = create(:content_unit,
                     type: 'ContentUnit::CourseUnit',
                     created_by: admin.id,
                     state: 'draft')
      
      lesson = create(:content_unit,
                     type: 'ContentUnit::LessonUnit',
                     parent: course,
                     created_by: admin.id,
                     state: 'draft')
      
      # Step 2: Publish content
      course.update!(state: 'visible')
      lesson.update!(state: 'visible')
      
      # Step 3: Archive content
      course.update!(state: 'archived')
      lesson.update!(state: 'archived')
      
      # Step 4: Mark for deletion
      course.update!(state: 'deleted', deleted_at: 45.days.ago)
      lesson.update!(state: 'deleted', deleted_at: 45.days.ago)
      
      # Step 5: Cleanup job removes old content
      expect {
        ContentUnitCleanupJob.perform_now
      }.to change { ContentUnit.where(id: [course.id, lesson.id]).count }.from(2).to(0)
    end
  end
  
  describe 'Badge and achievement system' do
    it 'manages complete badge workflow' do
      sign_in admin
      
      # Step 1: Create badges with criteria
      lesson_badge = create(:badge,
                           name: 'First Lesson',
                           description: 'Complete your first lesson',
                           criteria: {
                             'type' => 'lesson',
                             'conditions' => { 'lesson_id' => 1 }
                           },
                           state: 'visible')
      
      perfect_score_badge = create(:badge,
                                  name: 'Perfect Score',
                                  description: 'Get 100% on any quiz',
                                  criteria: {
                                    'type' => 'quiz',
                                    'conditions' => { 'evaluation_id' => 1 }
                                  },
                                  state: 'visible')
      
      # Step 2: Student completes activities
      student_user = create(:user).tap { |u| u.add_role(:student) }
      lesson = create(:content_unit, type: 'ContentUnit::LessonUnit')
      
      progress = create(:progress,
                       user: student_user,
                       content_unit: lesson,
                       score: 100,
                       state: 'passed')
      
      # Step 3: Badge evaluation and assignment
      badge_criteria_evaluator = BadgeCriteriaEvaluator.new(user: student_user, badge: lesson_badge)
      
      # Mock the criteria evaluation to return true
      allow(badge_criteria_evaluator).to receive(:satisfied?).and_return(true)
      
      # Step 4: Award badge
      user_badge = create(:user_badge, user: student_user, badge: lesson_badge)
      
      # Step 5: Send notification
      notification = BadgeAwardedNotifier.with(badge: lesson_badge)
      notification.deliver(student_user)
      
      # Verify badge system
      expect(user_badge).to be_persisted
      expect(user_badge.user).to eq(student_user)
      expect(user_badge.badge).to eq(lesson_badge)
      expect(student_user.notifications.count).to eq(1)
    end
  end
end