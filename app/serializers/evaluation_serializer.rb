class EvaluationSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :time_limit, :state, :content_unit_id
  has_many :questions
end
