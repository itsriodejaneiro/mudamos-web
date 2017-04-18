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

require_dependency "../petition_plugin"

class PetitionPlugin::Detail < ActiveRecord::Base
  acts_as_paranoid

  include PetitionPlugin

  belongs_to :plugin_relation
  belongs_to :city
  has_many :petition_detail_versions, class_name: 'PetitionPlugin::DetailVersion', dependent: :destroy, foreign_key: "petition_plugin_detail_id"

  SCOPE_COVERAGES = %w{nationwide statewide citywide}
  NATIONWIDE_SCOPE = SCOPE_COVERAGES.first
  STATEWIDE_SCOPE = SCOPE_COVERAGES.second
  CITYWIDE_SCOPE = SCOPE_COVERAGES.last
  UFS = %w(AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO)

  validates :call_to_action, presence: true
  validates :signatures_required, presence: true
  validates :presentation, presence: true
  validates :scope_coverage, presence: true, inclusion: { in: SCOPE_COVERAGES }
  validates :city, presence: true, if: -> { scope_coverage == CITYWIDE_SCOPE }
  validates :uf, presence: true, inclusion: { in: UFS }, if: -> { scope_coverage == STATEWIDE_SCOPE }

  validate :ensure_scope_coverage_detail

  validate :plugin_type_petition

  def past_versions
    return PetitionPlugin::DetailVersion.none unless published_version.present?
    petition_detail_versions.where "created_at < ?", published_version.created_at
  end

  def current_version
    petition_detail_versions.last
  end

  def published_version
    petition_detail_versions.where(published: true).last
  end

  SCOPE_COVERAGES.each do |scope|
    define_method "#{scope}?" do
      scope_coverage == scope
    end
  end

  # Do not allow setting incorrect scope coverage detail if the wrong scope
  def ensure_scope_coverage_detail
    has_city = city.present? || city_id.present?
    has_state = uf.present?

    invalid = (scope_coverage == NATIONWIDE_SCOPE && (has_city || has_state)) ||
              (scope_coverage == STATEWIDE_SCOPE && has_city) ||
              (scope_coverage == CITYWIDE_SCOPE && has_state)

    errors.add(:scope_coverage, :invalid) if invalid
  end

  def translated_scope_coverage
    self.class.translate_scope_coverage(scope_coverage)
  end

  def self.translate_scope_coverage(value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.scope_coverages.#{value}")
  end
end
