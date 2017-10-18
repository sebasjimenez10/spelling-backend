# frozen_string_literal: true
module Api
  class ExerciseSerializer < ActiveModel::Serializer
    attributes :message, :correctness_percentage, :wrong_letters_indexes
  end
end
