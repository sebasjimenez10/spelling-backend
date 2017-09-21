module Api
  class ExercisesController < ApplicationController
    def next_exercise
      word = WordService.fetch_word(params[:last_word_uuid], params[:solved_words])
      render json: word, serializer: Api::WordSerializer, status: :ok
    end
  end
end
