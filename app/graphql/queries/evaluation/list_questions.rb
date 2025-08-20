module Queries
  module Evaluation
    class ListQuestions < Queries::BaseQuery
      description "List questions for a content unit, optionally filtered by topic"
      type [ Types::Evaluation::QuestionType ], null: false

      argument :content_unit_id, ID, required: true
      argument :topic_id, ID, required: false

      def resolve(content_unit_id:, topic_id: nil)
        scope = ::Question
                  .joins(:evaluation)
                  .where(evaluations: { content_unit_id: content_unit_id })

        scope = scope.where(topic_id:) if topic_id
        scope
      end
    end
  end
end
