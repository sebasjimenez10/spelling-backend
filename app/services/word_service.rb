# frozen_string_literal: true
# Provides an interface to interact with the Word model
# and associated logic
class WordService
  class << self
    def next_word(last_word_uuid = nil, solved_words = [])
      Word.next_word(last_word_uuid, solved_words)
    end

    def evaluate_exercise(word_id, answer)
      # Raises exception if record not found
      word = Word.find(word_id)
      word.evaluate_answer(answer)
    end
  end
end
