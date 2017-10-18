class ExerciseEvaluation < ActiveModelSerializers::Model
  attributes :message, :correctness_percentage, :wrong_letters_indexes
end
