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
  def self.next_word(previous_words)
    if previous_words.present?
      where('id NOT IN (?)', previous_words).sample
    else
      all.sample
    end
  end

  def scramble_content
    content.downcase.chars.shuffle
  end
end
