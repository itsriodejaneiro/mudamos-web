# == Schema Information
#
# Table name: subjects_users
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  subject_id   :integer
#  agree        :boolean          default(FALSE)
#  deleted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  is_anonymous :boolean
#

class SubjectUser < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :user
  belongs_to :subject

  validates_presence_of :user_id, :subject_id
  validates_uniqueness_of :user_id, scope: :subject_id

  scope :for, -> (uid) { self.where{ user_id.eq uid }.limit(1) }

  def toggle_anonymity
    self.is_anonymous ^= true
    save
  end

end
