# == Schema Information
#
# Table name: petition_plugin_detail_versions
#
#  id                             :integer          not null, primary key
#  petition_plugin_information_id :integer          not null
#  document_url                   :string           not null
#  body                           :text             not null
#  deleted_at                     :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

require_dependency "../petition_plugin"

class PetitionPlugin::DetailVersion < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :petition_plugin_detail, class_name: 'PetitionPlugin::Detail'

  validates :body, presence: true
end
