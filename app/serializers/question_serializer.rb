class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :statement, :question_type, :position, :points
  has_many :answer_options
end
