# Rolify User Roles Seeds
# %w[guest student mentor academy admin super_admin].each do |role|
#     Role.find_or_create_by!(name: role)
# end

# User.create!(
#   email: "equix.dgs@gmail.com",
#   first_name: "EquiX",
#   last_name: "Digital",
#   phone_number: "+50687305888",
#   password: "uDdcF8H*ttmkgEy&Yck#",
#   password_confirmation: "uDdcF8H*ttmkgEy&Yck#",
#   confirmed_at: Time.now,
#   state: "active",
#   roles: [Role.find_by(name: "super_admin")]
# )

# Evaluation Seeds
# puts "== Creando evaluaciones demo =="

# admin_id      = 15
# quiz_time     = 10
# exam_time     = 30
# final_exam_time  = 60

# course = ContentUnit::CourseUnit.find_by!(slug: "ruby-silver")

# course.children.where(type: "Module").order(:position).each do |mod|
#   mod.children.where(type: "Segment").order(:position).each_with_index do |segment, idx|
#     Evaluation.find_or_create_by!(
#       content_unit: segment,
#       type:         "Quiz",
#       title:        "Quiz ##{idx + 1}: #{segment.title}",
#       description:  "Evalúa los contenidos de \"#{segment.title}\".",
#       time_limit:   quiz_time,
#       state:        :draft,
#       created_by:   admin_id
#     )
#   end
# end

# course.children.where(type: "Module").order(:position).each_with_index do |mod, idx|
#   Evaluation.find_or_create_by!(
#     content_unit: mod,
#     type:         "Exam",
#     title:        "Exam ##{idx + 1}: #{mod.title}",
#     description:  "Examen del módulo \"#{mod.title}\".",
#     time_limit:   exam_time,
#     state:        :draft,
#     created_by:   admin_id
#   )
# end

# Evaluation.find_or_create_by!(
#   content_unit: course,
#   type:         "Exam",
#   title:        "Final Exam: #{course.title}",
#   description:  "Examen final del curso.",
#   time_limit:   final_exam_time,
#   state:        :draft,
#   created_by:   admin_id
# )

# puts "== Evaluaciones creadas =="

# Questions, Answers, and Options Seeds
creator_id = 15
now = Time.current

QUIZ1  = Evaluation.find_by!(title: "Quiz #1 – Syntax Basic Station")
QUIZ2  = Evaluation.find_by!(title: "Quiz #2 – Flow Control Station")
EXAM1  = Evaluation.find_by!(title: "Exam #1 – Syntax and Basic Structures")

def create_mcq(evaluation, statement, options, correct_index:, creator:, pos:)
  q = evaluation.questions.find_or_create_by!(
        statement:       statement,
        question_type:   "single_choice",
        points:          1,
        position:        pos,
        created_by:      creator
      )

  q.answer_options.destroy_all

  options.each_with_index do |text, i|
    q.answer_options.create!(
      option_text: text,
      is_correct:  i == correct_index,
      position:    i + 1
    )
  end
end

quiz1_questions = [
  # [ statement, options[], correct_index ]
  [ "¿Cuál literal crea un símbolo en Ruby?",
    [ ":ruby", "'ruby'", "\"ruby\"", "%s[ruby]" ], 0 ],

  [ "¿Qué variable es *local* por convención?",
    [ "@name", "$name", "name", "@@name" ], 2 ],

  [ "El operador **<=>** devuelve…",
    [ "`true` o `false`", "un entero (-1, 0, 1)", "un símbolo", "una cadena" ], 1 ],

  [ "¿Cuál es la forma correcta de *here-document*?",
    [ "<<HEREDOC ... HEREDOC", "<<-HTML ... HTML", "<<~DOC ... DOC", "Todas las anteriores" ], 3 ],

  [ "En un método, los **keyword arguments** se definen con:",
    [ "*args", "**kwargs", ":key => value", "No existen en Ruby" ], 1 ]
]

quiz1_questions.each_with_index do |(stmt, opts, correct), idx|
  create_mcq(QUIZ1, stmt, opts, correct_index: correct, creator: creator_id, pos: idx + 1)
end

quiz2_questions = [
  [ "`yield` dentro de un método ejecuta…",
    [ "un bloque pasado al método", "el último return", "un proc almacenado en @block", "nada, es palabra reservada sin efecto" ], 0 ],

  [ "Diferencia principal entre **lambda** y **proc**:",
    [ "`return` sale del *caller* en ambos", "Arity estricto solo en lambda", "Los procs no son objetos", "Lambdas no pueden aceptar bloques" ], 1 ],

  [ "`in` y `=>` se utilizan para…",
    [ "*pattern matching*", "comparar rangos", "componer lambdas", "interpolación de cadenas" ], 0 ],

  [ "¿Qué excepción captura `rescue StandardError`?",
    [ "Todas, excepto SystemExit / NoMemoryError", "Solo RuntimeError", "Ninguna", "Todas sin excepción" ], 0 ],

  [ "`begin … ensure` se ejecuta siempre…",
    [ "solo si hay excepción", "solo si no hay excepción", "siempre, ocurra o no excepción", "nunca" ], 2 ]
]

quiz2_questions.each_with_index do |(stmt, opts, correct), idx|
  create_mcq(QUIZ2, stmt, opts, correct_index: correct, creator: creator_id, pos: idx + 1)
end

exam_questions = [
  [ "¿Qué literal produce un **Array** vacío?",           [ "[]", "{}", "()", "nil" ], 0 ],
  [ "`%%` en Ruby es:",                                   [ "operador módulo", "literal string", "no existe", "operador exponenciación" ], 1 ],
  [ "`@@counter` es una variable…",                       [ "global", "de instancia", "de clase", "constante" ], 2 ],
  [ "`5.times { |i| puts i }` imprimirá…",                 [ "0-5", "1-5", "0-4", "1-4" ], 2 ],
  [ "`->x { x * 2 }` retorna:",                           [ "un Proc lambda", "un método", "un bloque", "un Enumerator" ], 0 ],
  [ "¿Cuál operador tiene menor precedencia?",            [ "&&", "||", "==", "**" ], 1 ],
  [ "`case obj in {name:, age:}` es ejemplo de…",         [ "Hash rocket", "Desestructuración array", "Pattern matching", "Guard clause" ], 2 ],
  [ "Para forzar excepción personalizada usamos…",        [ "`fail` o `raise`", "`throw`", "`catch`", "`exit`" ], 0 ],
  [ "`File.open('a.txt') do |f| … end` usa patrón…",      [ "RAII", "Iterator", "Adapter", "Template" ], 0 ],
  [ "`defined?(var)` devuelve…",                          [ "true/false", "nil o descripción", "símbolo", "entero" ], 1 ]
]

exam_questions.each_with_index do |(stmt, opts, correct), idx|
  create_mcq(EXAM1, stmt, opts, correct_index: correct, creator: creator_id, pos: idx + 1)
end

puts "Preguntas, opciones y respuestas sembradas:"
puts "#{QUIZ1.questions.count} en #{QUIZ1.title}"
puts "#{QUIZ2.questions.count} en #{QUIZ2.title}"
puts "#{EXAM1.questions.count} en #{EXAM1.title}"
