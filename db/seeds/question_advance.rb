CREATOR_ID = 15

def ensure_settings!(evaluation, **cfg)
  s = evaluation.evaluation_setting || evaluation.build_evaluation_setting
  s.shuffle_questions = true if s.shuffle_questions.nil?
  s.show_results = true  if s.show_results.nil?
  s.show_feedback = false if s.show_feedback.nil?
  s.config = (s.config || {}).merge(cfg)
  s.save!
  s
end

def ensure_tf_true!(evaluation)
  return if evaluation.questions.exists?
  q = evaluation.questions.create!(
    statement: "Pregunta de avance: responde 'True' para continuar.",
    question_type: 2,
    position: 1,
    points: 1,
    created_by: CREATOR_ID
  )
  q.answer_options.create!(option_text: "True",  is_correct: true,  position: 1)
  q.answer_options.create!(option_text: "False", is_correct: false, position: 2)
end

titles = [
  "Quiz #1: Object Oriented Station",
  "Quiz #2: Modular Station",
  "Quiz #1: The Mirror Station",
  "Quiz #2: Gear Station",
  "Quiz #1: Central Core Station",
  "Quiz #2: Terminal Station",
  "Exam #2: Ruby as an Object-Oriented Language",
  "Exam #3: Metaprogramming and Ruby’s Dynamic Features",
  "Exam #4: Standard Libraries and Native Classes",
  "Final Exam: Ruby Programmer Silver Course"
]

titles.each do |title|
  ev = Evaluation.find_by!(title:)
  ev.update!(created_by: CREATOR_ID) if ev.created_by.blank?
  ensure_settings!(ev, advance_only: true, pass_score: 0)
  ensure_tf_true!(ev)
end

puts "[advance seeds] listo."
