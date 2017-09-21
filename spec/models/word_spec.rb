# == Schema Information
#
# Table name: words
#
#  id         :uuid             not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Word, type: :model do
  subject { Word.new }

  describe '#scramble_content' do
    let(:word) { create(:word) }

    it 'should return a scrambled version of the word\'s content' do
      scramble = word.scramble_content
      expect(scramble).not_to eq word.content
    end

    it 'should return scrambled word with the same length' do
      scramble = word.scramble_content
      expect(scramble.size).to eq word.content.size
    end
  end

  describe '::next_word' do
    let!(:word_one)   { create(:word) }
    let!(:word_two)   { create(:word, content: 'number') }
    let!(:word_three) { create(:word, content: 'before') }

    it 'should return the next word when no previous info is passed' do
      previous_words = [word_one.id]
      expect([word_two, word_three]).to include Word.next_word(previous_words)
    end
  end
end
