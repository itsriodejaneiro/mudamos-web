# == Schema Information
#
# Table name: petition_plugin_presignatures
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  plugin_relation_id :integer          not null
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PetitionPlugin::Presignature < ActiveRecord::Base
  acts_as_paranoid

  include PetitionPlugin

  belongs_to :user
  belongs_to :plugin_relation

  validates :user, presence: true, uniqueness: { scope: :plugin_relation_id }
  validates :plugin_relation, presence: true

  validate :plugin_type_petition
end
