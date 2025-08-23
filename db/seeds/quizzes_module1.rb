# === Helpers / enums seguros ===
SC_TYPES = Question.try(:question_types)&.symbolize_keys || {}
SC = SC_TYPES[:single_choice]   || 0
MC = SC_TYPES[:multiple_choice] || 1
TF = SC_TYPES[:true_false]      || 2

def mkq(e, type, stmt, options, correct_idx, explanation: nil, points: 1)
  q = e.questions.create!(
    statement: stmt,
    question_type: type,
    position: e.questions.count + 1,
    points: points
  )
  Array(options).each_with_index do |opt, idx|
    q.answer_options.create!(
      option_text: opt,
      is_correct: Array(correct_idx).include?(idx),
      position: idx + 1
    )
  end
  q.update!(explanation: explanation) if explanation
  q
end

def ensure_settings!(evaluation, **cfg)
  s = evaluation.evaluation_setting || evaluation.build_evaluation_setting
  s.shuffle_questions = true if s.shuffle_questions.nil?
  s.show_results = true if s.show_results.nil?
  s.show_feedback = false if s.show_feedback.nil?
  s.config = (s.config || {}).merge(cfg)
  s.save!
end

quiz1 = Evaluation.find_by!(title: 'Quiz #1: Syntax Basic Station')        # content_unit_id: 16
quiz2 = Evaluation.find_by!(title: 'Quiz #2: Flow Control Station')        # content_unit_id: 17
exam1 = Evaluation.find_by!(title: 'Exam #1: Syntax and Basic Structures') # content_unit_id: 12

ensure_settings!(quiz1)
ensure_settings!(quiz2)
ensure_settings!(exam1)

# -----------------------------
# QUIZ #1 (Segment 16: Literals, Variables/Constants, Operators, Special Params)
# -----------------------------

# Literals
mkq(quiz1, SC, "Which is a Hash literal mapping :a=>1 and :b=>2?",
  [ "{a: 1, b: 2}", "[[:a,1],[:b,2]]", "%i[a b]", "{'a' => :b}" ], 0)

mkq(quiz1, TF, "The literal /\\A[a-z]+\\z/i is a Regexp that matches only letters ignoring case.",
  [ "True", "False" ], 0)

# Variables & Constants
mkq(quiz1, SC, "Which identifier is a constant by Ruby convention?",
  [ "MAX_RETRIES", "_value", "price", "$cache" ], 0,
  explanation: "Constants start with uppercase; reassignment emite warning.")

mkq(quiz1, SC, "An instance variable belongs to the object’s state and starts with…",
  [ "@", "$", "@@", "no prefix" ], 0)

# Operators
mkq(quiz1, SC, "Which operator tests case-equality in a case/when?",
  [ "===", "=~", "==", "<=>" ], 0)

mkq(quiz1, SC, "Safe navigation to call #first only if not nil is written as:",
  [ "arr&.first", "arr?.first", "arr!!first", "arr&first" ], 0)

# Special Parameters (heredoc, kwargs, numbered params)
mkq(quiz1, SC, "Which heredoc keeps indentation trimmed?",
  [ "<<~TEXT", "<<-TEXT", "<<=TEXT", "<<TEXT" ], 0)

mkq(quiz1, SC, "Numbered block param that references the first arg is:",
  [ "_1", "arg1", "$1", "it" ], 0)

# -----------------------------
# QUIZ #2 (Segment 17: Blocks/Yield, Lambdas vs Procs, Pattern Matching, Error Mgmt)
# -----------------------------

# Blocks & yield
mkq(quiz2, SC, "How does a method invoke a passed block?",
  [ "yield", "call(block)", "exec", "invoke" ], 0,
  explanation: "El método invoca el bloque con 'yield' y puede pasarle argumentos.")

mkq(quiz2, SC, "Preferred delimiter for multi-line blocks is:",
  [ "do..end", "{ } only", "begin..end", "lambda..end" ], 0)

# Lambdas vs Procs
mkq(quiz2, TF, "A lambda enforces arity strictly; a Proc (Proc.new) is lax with missing args.",
  [ "True", "False" ], 0)

mkq(quiz2, SC, "Inside a lambda, 'return' returns from…",
  [ "the lambda", "the enclosing method", "the class", "the program" ], 0)

# Pattern Matching
mkq(quiz2, SC, "Which operator performs Regexp match returning index or nil?",
  [ "=~", "===", "=>", "||=" ], 0)

mkq(quiz2, SC, "In case/in structural patterns (Ruby ≥ 2.7), the keyword to match destructuring is:",
  [ "in", "match", "when*", "with" ], 0)

# Error Management
mkq(quiz2, SC, "Which clause runs regardless of rescue?",
  [ "ensure", "finally", "after", "always" ], 0)

mkq(quiz2, SC, "Which is the correct way to capture an exception object?",
  [ "rescue ArgumentError => e", "rescue as e: ArgumentError", "catch ArgumentError => e", "rescue => ArgumentError" ], 0)

# -----------------------------
# EXAM #1 (Module 12) — compila preguntas de ambos pools y añade algunas extras
# -----------------------------
# Toma todas las preguntas existentes de quiz1 y quiz2, y (si hay menos de 24) crea extras.
pool = quiz1.questions.to_a + quiz2.questions.to_a

# Extras rápidas (6) para llegar a 24
extras = [
  [ "Which creates an Array of strings quickly?", [ "%w[red green]", "%i[red green]", "{red: green}", "Array<'red','green'>" ], 0 ],
  [ "Which operator returns MatchData in $~ upon success?", [ "=~", "===", "<=>", "!~" ], 0 ],
  [ "In a hash literal with symbol keys, choose the Ruby 1.9+ style:", [ "{a: 1, b: 2}", "{:a => 1; :b => 2}", "{'a': 1, 'b': 2}", "{a -> 1, b -> 2}" ], 0 ],
  [ "Keyword args example:", [ "def connect(host:, port: 443) end", "def connect(host, :port) end", "def connect(host:; port=443) end", "def connect(:host, :port) end" ], 0 ],
  [ "Which closes file no matter what?", [ "ensure", "finally", "closing", "rescue" ], 0 ],
  [ "Proc vs lambda arity:", [ "lambda is strict; proc is lax", "both strict", "both lax", "proc strict; lambda lax" ], 0 ]
]

needed = [ 0, 24 - pool.size ].max
extras.first(needed).each do |(stmt, opts, correct)|
  mkq(exam1, SC, stmt, opts, correct)
end

ensure_settings!(exam1, pass_score: 80)
puts "Done: #{quiz1.questions.count} Q in Quiz #1; #{quiz2.questions.count} Q in Quiz #2; #{exam1.questions.count} Q in Exam #1"
