require 'rails_helper'

RSpec.describe 'Exercises API', type: :request do
  describe 'GET /exercises/next_exercise' do
    it 'should return the next exercise' do
      get next_exercise_path
      expect(json.keys).to include [:word_id, :scrambled_word, :original_word]
    end
  end
end
