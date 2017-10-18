module Api
  class ExercisesController < ApplicationController
    # Searches for words excluding the last attempted word if passed
    # and the solved words if passed
    def next_exercise
      word = WordService.next_word(last_word_id, solved_words.to_a)
      render json: word, serializer: Api::WordSerializer, status: (word.present? ? :ok : :not_found)
    end

    # Evaluates the word based on th answer
    # if the word_id does not exist it will response with a not_found http code
    def evaluate_exercise
      evaluation = WordService.evaluate_exercise(word_id, answer)
      render json: evaluation, serializer: Api::ExerciseSerializer, status: :ok
    end

    private

    # Optional parameter
    def solved_words
      params.permit(solved_words: [])[:solved_words]
    end

    # Optional parameter
    def last_word_id
      params.permit(:last_word_id)[:last_word_id]
    end

    # Required parameter
    def word_id
      params.require(:word_id)
    end

    # Required parameter
    def answer
      params.require(:answer)
    end
  end
end
