class ChangeEvaluationSectionIdToNullableInQuestions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :questions, :evaluation_section_id, true
  end
end
