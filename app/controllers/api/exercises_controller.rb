module Api
  class ExercisesController < ApplicationController
    # Searches for words excluding the last attempted word if passed
    # and the solved words if passed
    def next_exercise
      word = WordService.find_word(last_word_id, solved_words)
      if word.present?
        render json: word, serializer: Api::WordSerializer, status: :ok
      else
        render json: { message: 'You\'ve solved all the words in our dictionary' }, status: :not_found
      end
    end

    # Evaluates the word based on th answer
    # if the word_id does not exist it will response with a not_found http code
    def evaluate_exercise
      evaluation = WordService.evaluate_exercise(word_id, answer)
      if evaluation.present?
        render json: evaluation, status: :ok
      else
        render json: { message: 'Incorrect Word ID' }, status: :not_found
      end
    end

    private

    # Optional parameter
    def solved_words
      params.require(:solved_words) if params[:solved_words]
    end

    # Optional parameter
    def last_word_id
      params.require(:last_word_id) if params[:last_word_id]
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
