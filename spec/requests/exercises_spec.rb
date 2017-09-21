require 'rails_helper'

RSpec.describe 'Exercises API', type: :request do
  describe 'GET /exercises/next_exercise' do
    let!(:word) { create(:word) }

    it 'should return an exercise with the expected keys' do
      get next_exercise_path
      expect(json.keys).to include 'word_id', 'original_word', 'scrambled'
    end

    it 'should return the expected exercise record' do
      get next_exercise_path
      expect(json['word_id']).to eq word.id
      expect(json['original_word']).to eq word.content

      # Since the scrambled word calculation is random
      # we can't know what that value will be
      expect(json['scrambled'].size).to eq word.content.size
    end

    context 'when already solved an exercise' do
      let!(:another_word) { create(:word, content: 'apple') }

      it 'should return a word not solved before' do
        get next_exercise_path, params: { solved_words: [word.id] }
        expect(json['word_id']).to eq another_word.id
      end
    end
  end
end
