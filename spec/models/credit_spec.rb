# == Schema Information
#
# Table name: credits
#
#  id                 :integer          not null, primary key
#  credit_category_id :integer
#  name               :string
#  content            :text
#  url                :string
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Credit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
