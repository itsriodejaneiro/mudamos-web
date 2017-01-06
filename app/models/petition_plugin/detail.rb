# == Schema Information
#
# Table name: petition_plugin_details
#
#  id                 :integer          not null, primary key
#  plugin_relation_id :integer          not null
#  call_to_action     :string           not null
#  sinatures_required :integer          not null
#  presentation       :string           not null
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PetitionPlugin::Detail < ActiveRecord::Base
  acts_as_paranoid

  include PetitionPlugin

  belongs_to :plugin_relation
  has_many :petition_detail_versions, class_name: 'PetitionPlugin::DetailVersion', dependent: :destroy, foreign_key: "petition_plugin_detail_id"
  
  validates :call_to_action, presence: true
  validates :signatures_required, presence: true
  validates :presentation, presence: true

  validate :plugin_type_petition

  def current_version
    petition_detail_versions.last
  end
end
