module Api
  class ExercisesController < ApplicationController
    def next_exercise
      word = WordService.fetch_word(params[:last_word_uuid], params[:solved_words])
      render json: word, serializer: Api::WordSerializer, status: :ok
    end

    private

    def permit_filters
      params.permit(:last_word_uuid, :solved_words)
    end
  end
end
