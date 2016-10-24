# == Schema Information
#
# Table name: credit_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  position   :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CreditCategory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
