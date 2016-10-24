# == Schema Information
#
# Table name: phases
#
#  id                   :integer          not null, primary key
#  cycle_id             :integer
#  name                 :string
#  description          :string
#  tooltip              :string
#  initial_date         :datetime
#  final_date           :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

class Phase < ActiveRecord::Base
  acts_as_paranoid
  extend FriendlyId
  friendly_id :name

  default_scope { order(:initial_date) }

  belongs_to :cycle

  has_one :plugin_relation, as: :related, dependent: :destroy
  accepts_nested_attributes_for :plugin_relation, reject_if: :all_blank, allow_destroy: true

  delegate :plugin, to: :plugin_relation

  has_many :permissions, as:  :target

  has_attached_file :picture

  scope :finished, -> {
    where{ final_date < Time.zone.now }
  }

  scope :in_progress, -> {
    where{ (initial_date <= Time.zone.now) & (final_date >= Time.zone.now) }
  }

  scope :shortly, -> {
    where{ initial_date > Time.zone.now }
  }

  def finished?
    self.final_date < Time.zone.now
  end

  def in_progress?
    (self.initial_date <= Time.zone.now) and (self.final_date >= Time.zone.now)
  end

  def shortly?
    self.initial_date > Time.zone.now
  end

  def self.statuses
    [:finished, :in_progress, :shortly]
  end

  def current_status
    if self.in_progress?
      'Em andamento'
    elsif self.shortly?
      'Em breve'
    elsif self.finished?
      'Encerrado'
    end
  end


  # validates_attachment :picture, presence: true, content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png', 'image/jpg'] }
  validates_presence_of :name, :description, :initial_date, :final_date, :cycle
  validate :validate_dates, unless: -> { self.initial_date.nil? || self.final_date.nil? }
  validate :valid_plugin_type, if: -> { self.plugin_relation.present? }

  private

    def validate_dates
      if initial_date > self.final_date
        errors.add(:initial_date, 'must come before final_date')
        errors.add(:final_date, 'must come after initial_date')
      end
    end

    def valid_plugin_type
      unless ["Discussão", "Relatoria"].include? self.plugin_relation.plugin.plugin_type
        self.plugin_relation.errors.add :plugin, "deve ser do tipo discussão ou relatoria."
      end
    end
end
