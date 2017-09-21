module Api
  class ExercisesController < ApplicationController
    def next_exercise
      word = WordService.fetch_word(last_word_id, solved_words)
      render json: word, serializer: Api::WordSerializer, status: :ok
    end

    private

    def solved_words
      params.require(:solved_words) if params[:solved_words]
    end

    def last_word_id
      params.require(:last_word_id) if params[:last_word_id]
    end
  end
end
