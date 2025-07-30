module Mutations
  module Progress
    class CompleteContentUnit < Base::BaseMutation
      argument :id, ID, required: true
      field :progress, Types::Progress::ProgressType, null: false
      field :course_completion, Integer, null: false

      def resolve(id:)
        cu = ::ContentUnit.find(id)
        prog = ::Progress.find_or_initialize_by(
          user: context[:current_user],
          content_unit: cu
        )
        prog.update!(state: :passed, completed_at: Time.current)

        percent = cu.root_course.completion_percent_for(context[:current_user])
        { progress: prog, course_completion: percent }
      end
    end
  end
end
