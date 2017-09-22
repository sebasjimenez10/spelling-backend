class WordService
  class << self
    def fetch_word(last_word_uuid = nil, solved_words = [])
      previous_words = [*solved_words, last_word_uuid].compact
      word = Word.next_word(previous_words)
      # This covers an edge case with the last word in the db not being solved
      word = Word.next_word([*solved_words]) unless word.present?
      word
    end

    def evaluate_exercise(word_id, answer)
      word = Word.where(id: word_id).first
      word.evaluate_answer(answer) if word.present?
    end
  end
end
