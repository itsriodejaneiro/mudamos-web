# == Schema Information
#
# Table name: plugin_relations
#
#  id           :integer          not null, primary key
#  related_id   :integer
#  related_type :string
#  plugin_id    :integer
#  is_readonly  :boolean
#  read_only_at :datetime
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  slug         :string
#

class PluginRelation < ActiveRecord::Base
  acts_as_paranoid

  extend FriendlyId
  friendly_id :plugin_name, use: :scoped, scope: [:related_id, :related_type]

  belongs_to :related, polymorphic: true
  belongs_to :plugin

  has_many :permissions, as: :target, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :blog_posts, dependent: :destroy
  has_many :vocabularies, dependent: :destroy
  has_many :materials, dependent: :destroy

  has_one :compilation_file

  scope :blog, -> {
    includes(:plugin).where(plugins: { plugin_type: 'Blog' })
  }

  def cycle
    if self.related.is_a? Cycle
      self.related
    elsif self.related.is_a? Phase
      self.related.cycle
    end
  end

  def plugin_name
    self.plugin.name if self.plugin.present?
  end

  validates_presence_of :related, :plugin

  after_create :create_compilation_file, if: -> { self.plugin.present? and self.plugin.plugin_type == 'Relatoria' }

  private

    def create_compilation_file
      cf = CompilationFile.new(plugin_relation: self)
      self.compilation_file = cf

      cf.save
    end
end

