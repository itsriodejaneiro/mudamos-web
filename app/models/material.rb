# == Schema Information
#
# Table name: materials
#
#  id                 :integer          not null, primary key
#  author             :string
#  title              :string
#  source             :string
#  publishing_date    :datetime
#  category           :string
#  external_link      :string
#  themes             :string
#  keywords           :string
#  description        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cycle_id           :integer
#  position           :integer
#  plugin_relation_id :integer
#

class Material < ActiveRecord::Base
  acts_as_taggable_on :themes, :keywords

  # default_scope { order('position ASC') }

  include PgSearch
  pg_search_scope :material_search,
                  against: [
                    :title,
                    :author,
                    :description,
                    :themes,
                    :keywords
                  ],
                  ignoring: :accents,
                  using: [:tsearch, :trigram]

  validates_presence_of :title, :external_link, :cycle, :description, :plugin_relation

  belongs_to :plugin_relation
  belongs_to :cycle

  # default_scope { order('description DESC NULLS LAST, title ASC') }

  #Overriding default getters and setters (using comma separated values for the setters!)
  def themes= value
    self.theme_list.clear
    if value.is_a? String
      self.theme_list.add(value.split(';').map { |x| x.split(',') }.flatten.map { |x| x.strip }.reject { |x| x.blank? })
    end
  end

  def keywords= value
    self.keyword_list.clear
    if value.is_a? String
      self.keyword_list.add(value.split(';').split(',').flatten.map { |x| x.strip }.reject { |x| x.blank? })
    end
  end

  def themes
    self.theme_list
  end

  def keywords
    self.keyword_list
  end

  def category_icon
    case self.category
    when "Vídeo"
      'video'
    when 'Entrevista'
      'interview'
    when 'entrevista'
      'interview'
    when 'Manifesto'
      'manifesto'
    when 'Site'
      'site'
    else
      'text'
    end
  end

  def self.categories
    ["Vídeo", "Entrevista", "Manifesto", "Site", "Artigo"]
  end

 #Class method to return all the tags separated by column
  def self.tag_list
    ret = Hash.new
    ret['themes'] = theme_counts.pluck(:name)
    ret['keywords'] = keyword_counts.pluck(:name)
    ret
  end
end
