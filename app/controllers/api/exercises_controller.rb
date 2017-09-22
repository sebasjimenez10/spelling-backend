module Api
  class ExercisesController < ApplicationController
    def next_exercise
      word = WordService.fetch_word(last_word_id, solved_words)
      if word.present?
        render json: word, serializer: Api::WordSerializer, status: :ok
      else
        render json: { message: 'You\'ve solved all the words in our dictionary' }, status: :not_found
      end
    end

    def evaluate_exercise
      evaluation = WordService.evaluate_exercise(word_id, answer)
      if evaluation.present?
        render json: evaluation, status: :ok
      else
        render json: { message: 'Incorrect Word ID' }, status: :not_found
      end
    end

    private

    def solved_words
      params.require(:solved_words) if params[:solved_words]
    end

    def last_word_id
      params.require(:last_word_id) if params[:last_word_id]
    end

    def word_id
      params.require(:word_id)
    end

    def answer
      params.require(:answer)
    end
  end
end
