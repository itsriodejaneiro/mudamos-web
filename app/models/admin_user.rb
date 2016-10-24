# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  password               :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin_type             :integer          default(0)
#

class AdminUser < ActiveRecord::Base
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  has_many :notifications, -> { order('created_at DESC') }, as: :target_user, dependent: :destroy

  enum admin_type: { 'Master' => 1, 'Moderador' => 0 }

  def self.to_csv
    CSV.generate(col_sep: "\t") do |csv|
      h = {
        id: "ID",
        email: "E-mail",
        name: "Nome",
        created_at: "Data de Criação",
        sign_in_count: "Número de Logins",
        last_sign_in_at: "Hora do último login",
        last_sign_in_ip: "IP do último login"
      }

      csv << h.values

      self.all.each do |item|
        values = h.keys.map do |k|
          item.send(k)
        end

        csv << values
      end
    end
  end
end
