module Api
  class WordSerializer < ActiveModel::Serializer
    attribute :id,         key: :word_id
    attribute :content,    key: :original_word
    attributes :scrambled

    def scrambled
      object.scramble_content
    end
  end
end
