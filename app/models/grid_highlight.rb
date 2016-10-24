# == Schema Information
#
# Table name: grid_highlights
#
#  id                 :integer          not null, primary key
#  target_object_id   :integer
#  target_object_type :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  blog               :boolean          default(FALSE)
#  vocabulary         :boolean          default(FALSE)
#

class GridHighlight < ActiveRecord::Base
  belongs_to :target_object, polymorphic: true
end
