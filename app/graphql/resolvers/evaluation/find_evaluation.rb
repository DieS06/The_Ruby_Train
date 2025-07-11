module Resolvers
  module Evaluation
    class FindEvaluation < Resolvers::BaseResolver
      type Types::Evaluation::EvaluationType, null: false
      argument :id, ID, required: true

      def resolve(id:)
        record = ::Evaluation.find(id)
        raise CanCan::AccessDenied unless record.visible_for?(context[:current_user])
        record
      end
    end
  end
end
