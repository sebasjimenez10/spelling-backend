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
  pending "add some examples to (or delete) #{__FILE__}"
end
