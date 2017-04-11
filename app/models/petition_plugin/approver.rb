require_dependency "../petition_plugin"

class PetitionPlugin::Approver < ActiveRecord::Base
  include PetitionPlugin

  belongs_to :plugin_relation

  validates :email, uniqueness: { scope: :plugin_relation_id }, presence: true
end
