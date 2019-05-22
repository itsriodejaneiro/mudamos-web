# == Schema Information
#
# Table name: faq
#
#  id                     :integer          not null, primary key
#  title                  :string
#  content                :integer
#  published              :boolean          default(TRUE)
#  sequence               :integer
#  admin_user_id          :integer
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Faq < ActiveRecord::Base
  acts_as_paranoid
  validates :title, :content, presence: true

  belongs_to :admin_user
  before_save :strip_title
  before_create :set_default_sequence

  default_scope { order(:sequence) }
  scope :published, -> { where(published: true) }

  def strip_title
    self.title = self.title.strip
  end

  def set_default_sequence
    self.sequence = Faq.count if self.sequence.nil?
  end

  def insert_at_sequence(new_position)
    Faq.transaction do
      old_position = self.sequence_changed? ? self.sequence_was : self.sequence
      self.sequence = new_position
      self.save!

      if old_position < new_position
        faqs = Faq.order(sequence: :asc, updated_at: :asc)
      else
        faqs = Faq.order(sequence: :asc, updated_at: :desc)
      end

      faqs.where('sequence >= ?', [old_position, new_position].min).map.with_index do |f, index|
        f.sequence = index + [old_position, new_position].min
        f.save!
      end
    end
  end
end
