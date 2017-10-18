# frozen_string_literal: true
# == Schema Information
#
# Table name: words
#
#  id         :uuid             not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Word < ApplicationRecord
  # Find a word which is not included in the list of previous words if passed
  # if there aren't previous words it will go ahead and sample any of all of the words
  # in the dictionary
  scope :unsolved_words, ->(solved_word_ids) { where('id NOT IN (?)', solved_word_ids) }

  def self.next_word(last_word_id, solved_words)
    words = unsolved_words(solved_words)
    words = words.reject { |word| word.id == last_word_id } if words.size <= 1
    words = all unless words.present?
    words.sample
  end

  # Returns a scrambled representation of the word's content
  def scramble_content
    shuffled = content.downcase.chars.shuffle
    shuffled = content.downcase.chars.shuffle while shuffled.join == content
    shuffled
  end

  # Evaluates an answer and gives feedback about the answer given
  def evaluate_answer(answer)
    percentage            = similarity_percentage(answer).round(2)
    wrong_letters_indexes = calculate_wrong_letters(answer)
    message               = calculate_message(percentage, wrong_letters_indexes.size)

    ExerciseEvaluation.new(message: message, correctness_percentage: percentage, wrong_letters_indexes: wrong_letters_indexes)
  end

  private

  def calculate_message(percentage, wrong_letters_count)
    case percentage
    when 0.0..49.9
      'Your answer was not that close'
    when 50.0..74.9
      'You were almost there!'
    when 75.0..98.9
      "You only missed #{wrong_letters_count} letter(s)"
    when 99.0..100.0
      'You got it right, Congrats!'
    end
  end

  def calculate_wrong_letters(answer)
    answer_chars = answer.chars
    content.chars.each_with_index.map do |ch, i|
      answer_chars[i] != ch ? i : nil
    end.compact
  end

  def similarity_percentage(answer)
    ((content.length.to_f - calculate_wrong_letters(answer).length.to_f) / content.length.to_f) * 100.0
  end
end
