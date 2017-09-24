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
  def self.next_word(previous_words)
    if previous_words.present?
      where('id NOT IN (?)', previous_words).sample
    else
      all.sample
    end
  end

  # Returns a scrambled representation of the word's content
  def scramble_content
    shuffled = content.downcase.chars.shuffle
    shuffled = content.downcase.chars.shuffle while shuffled.join == content
    shuffled
  end

  # Evaluates an answer and gives feedback about the answer given
  def evaluate_answer(answer)
    percentage = similarity_percentage(answer).round(2)

    message = if percentage <= 25.0
                'Your answer was not that close'
              elsif percentage > 25.0 && percentage <= 50.0
                'Your answer was not so bad, but still far from correct'
              elsif percentage > 50.0 && percentage < 75.0
                'You were almost there!'
              elsif percentage >= 75.0 && percentage < 100.0
                "You only missed #{calculate_wrong_letters(answer).length} letter(s)"
              elsif percentage == 100.0
                'You got it right, Congrats!'
              end
    {
      message: message,
      correctness_percentage: percentage,
      wrong_letters_indexes: calculate_wrong_letters(answer)
    }
  end

  private

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
