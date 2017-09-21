class WordService
  class << self
    def fetch_word(last_word_uuid = nil, solved_words = [])
      previous_words = [*solved_words, last_word_uuid].compact
      Word.next_word(previous_words)
    end
  end
end
