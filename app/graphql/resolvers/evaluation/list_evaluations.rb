module Resolvers
  module Evaluation
    class ListEvaluations < Resolvers::BaseResolver
      type [ Types::Evaluation::EvaluationType ], null: false

      def resolve
        user = context[:current_user]
        if user.has_role?(:admin) || user.has_role?(:super_admin)
          ::Evaluation.all
        else
          ::Evaluation.visible.or(::Evaluation.where(created_by: user.id))
        end
      end
    end
  end
end
