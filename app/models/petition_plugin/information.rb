# == Schema Information
#
# Table name: petition_plugin_information
#
#  id                 :integer          not null, primary key
#  plugin_relation_id :integer          not null
#  call_to_action     :string           not null
#  sinatures_required :integer          not null
#  presentation       :string           not null
#  document_url       :string           not null
#  body               :text             not null
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PetitionPlugin::Information < ActiveRecord::Base
  acts_as_paranoid

  include PetitionPlugin

  belongs_to :plugin_relation
  
  validates :call_to_action, presence: true
  validates :signatures_required, presence: true
  validates :presentation, presence: true
  validates :body, presence: true
  validates :document_url, presence: true

  validate :plugin_type_petition
end
