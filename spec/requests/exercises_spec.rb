require 'rails_helper'

RSpec.describe 'Exercises API', type: :request do
  describe 'GET /exercises/next_exercise' do
    let!(:word) { create(:word) }

    it 'should return an exercise with the expected keys' do
      get next_exercise_path
      expect(response.status).to eq 200
      expect(json.keys).to include 'word_id', 'original_word', 'scrambled'
    end

    it 'should return the expected exercise record' do
      get next_exercise_path
      expect(response.status).to eq 200
      expect(json['word_id']).to eq word.id
      expect(json['original_word']).to eq word.content

      # Since the scrambled word calculation is random
      # we can't know what that value will be
      expect(json['scrambled'].size).to eq word.content.size
      expect(json['scrambled'].class).to eq Array
    end

    context 'when already solved an exercise' do
      let!(:another_word) { create(:word, content: 'apple') }

      it 'should return a word not solved before' do
        get next_exercise_path, params: { solved_words: [word.id] }
        expect(response.status).to eq 200
        expect(json['word_id']).to eq another_word.id
      end
    end

    # Pending scenario
    # context 'when solved all exercises' do
    #   let!(:another_word) { create(:word, content: 'apple') }

    #   it 'should return a message saying that all words have been solved' do
    #     get next_exercise_path, params: { solved_words: [word.id, another_word.id] }
    #     expect(response.status).to eq 404
    #     expect(json['message']).to eq 'You\'ve solved all the words in our dictionary'
    #   end
    # end

    context 'when there is only one word pending to be solved' do
      let!(:another_word) { create(:word, content: 'apple') }
      let!(:last_word) { create(:word, content: 'apple') }

      it 'should return the last available word' do
        get next_exercise_path, params: { solved_words: [word.id, another_word.id], last_word_uuid: last_word.id }
        expect(response.status).to eq 200
        expect(json['word_id']).to eq last_word.id
      end
    end
  end

  describe 'GET /exercises/evaluate_exercise' do
    let!(:word) { create(:word, content: 'examples') }

    before do
      get next_exercise_path
      @exercise = json
    end

    it 'should fail when the answer is wrong' do
      get evaluate_exercise_path, params: { word_id: @exercise['word_id'], answer: 'xamseple' }
      expect(response.status).to eq 200

      expect(json['correctness_percentage']).to eq 0.0
      expect(json['message']).to eq 'Your answer was not that close'
      expect(json['wrong_letters_indexes']).to eq [0, 1, 2, 3, 4, 5, 6, 7]
    end

    it 'should pass when the answer is correct' do
      get evaluate_exercise_path, params: { word_id: @exercise['word_id'], answer: 'examples' }
      expect(response.status).to eq 200

      expect(json['correctness_percentage']).to eq 100.0
      expect(json['message']).to eq 'You got it right, Congrats!'
      expect(json['wrong_letters_indexes']).to eq []
    end

    it 'should not pass but indicate it was close' do
      get evaluate_exercise_path, params: { word_id: @exercise['word_id'], answer: 'exampsle' }
      expect(response.status).to eq 200

      expect(json['correctness_percentage'].round(2)).to eq 62.50
      expect(json['message']).to eq 'You were almost there!'
      expect(json['wrong_letters_indexes']).to eq [5, 6, 7]
    end

    it 'should not pass but indicate how many letters were missed' do
      get evaluate_exercise_path, params: { word_id: @exercise['word_id'], answer: 'examplse' }
      expect(response.status).to eq 200

      expect(json['correctness_percentage'].round(2)).to eq 75.00
      expect(json['message']).to eq 'You only missed 2 letter(s)'
      expect(json['wrong_letters_indexes']).to eq [6, 7]
    end

    it 'should not pass but indicate how many letters were missed' do
      get evaluate_exercise_path, params: { word_id: @exercise['word_id'], answer: 'examlesp' }
      expect(response.status).to eq 200

      expect(json['correctness_percentage'].round(2)).to eq 50.00
      expect(json['message']).to eq 'You were almost there!'
      expect(json['wrong_letters_indexes']).to eq [4, 5, 6, 7]
    end

    it 'should return not_found when word_id is incorrect' do
      get evaluate_exercise_path, params: { word_id: 'invalid_uuid', answer: 'examlesp' }
      expect(response.status).to eq 404
      expect(json['message']).to eq "Couldn't find Word with 'id'=invalid_uuid"
    end

    it 'should require the answer parameter' do
      get evaluate_exercise_path, params: { word_id: 'invalid_uuid' }
      expect(response.status).to eq 422
      expect(json['message']).to eq 'param is missing or the value is empty: answer'
    end

    it 'should require the word_id parameter' do
      get evaluate_exercise_path
      expect(response.status).to eq 422
      expect(json['message']).to eq 'param is missing or the value is empty: word_id'
    end
  end
end
