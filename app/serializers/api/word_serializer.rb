# frozen_string_literal: true
module Api
  class WordSerializer < ActiveModel::Serializer
    attribute :id,               key: :word_id
    attribute :content,          key: :original_word
    attribute :scramble_content, key: :scrambled
  end
end
