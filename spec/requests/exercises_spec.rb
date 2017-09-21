require 'rails_helper'

RSpec.describe 'Exercises API', type: :request do
  describe 'GET /exercises/next_exercise' do
    let!(:word) { create(:word) }

    it 'should return the next exercise' do
      get next_exercise_path
      expect(json.keys).to include 'word_id', 'original_word', 'scrambled'
    end
  end
end
