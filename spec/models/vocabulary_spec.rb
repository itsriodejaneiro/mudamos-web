# == Schema Information
#
# Table name: vocabularies
#
#  id                 :integer          not null, primary key
#  cycle_id           :integer
#  title              :string
#  first_letter       :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  plugin_relation_id :integer
#

require 'rails_helper'

RSpec.describe Vocabulary, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
