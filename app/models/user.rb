# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  deleted_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  profile_id             :integer
#  birthday               :date
#  picture_file_name      :string
#  picture_content_type   :string
#  picture_file_size      :integer
#  picture_updated_at     :datetime
#  alias_as_default       :boolean          default(FALSE)
#  sub_profile_id         :integer
#  gender                 :integer
#  encrypted_name         :string
#  encrypted_cpf          :string
#  encrypted_birthday     :string
#  encrypted_state        :string
#  encrypted_city         :string
#  encrypted_alias_name   :string
#  encrypted_email        :string
#  is_admin               :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  acts_as_paranoid

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  attr_encrypted :name, :cpf, :state, :city, :alias_name, :email, key: ENV['ENCRYPTION_KEY']

  include PgSearch
  pg_search_scope :user_search,
                  against: [
                    :encrypted_name
                  ],
                  # ignoring: :accents,
                  using: [:tsearch]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  default_scope { includes(:profile, :sub_profile).where(is_admin: false) }

  scope :created_before, -> (date) { where{ created_at <= date } }
  scope :created_after, -> (date) { where{ created_at <= date } }
  scope :in_daterange, -> (start_date, end_date) {
    where(created_at: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day)
  }

  belongs_to :profile
  belongs_to :sub_profile, class_name: 'Profile'

  has_many :session_tokens, dependent: :destroy
  has_many :omniauth_identities, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_many :reports, dependent: :destroy

  has_attached_file :picture, preserve_files: true, styles: { medium: "300x300", thumb: "100x100" }, processors: [:thumbnail], default_url: 'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/modonormal_ultimaversao-01.png'

  has_many :comments, dependent: :destroy
  has_many :subjects_users, dependent: :destroy
  has_many :notifications, -> { order('created_at DESC') }, as: :target_user, dependent: :destroy

  enum gender: { 'Feminino' => 1, 'Masculino' => 0, 'Transgênero' => 2, 'Não quero opinar' => 3 }

  attr_accessor :first_step, :terms

  def self.anonymous_picture_url
    'https://s3-sa-east-1.amazonaws.com/mudamos-images/images/modoanonimo_ultimaversao-01.png'
  end

  def anonymous_picture_url
    self.class.anonymous_picture_url
  end

  def first_step= value
    if value == 'true' or value == '1' or value == true
      @first_step = true
    else
      @first_step = false
    end
  end

  def first_step
    @first_step || false
  end

  def terms= value
    if value == '1' or value == 'true'
      value = true
    end

    @terms = value
  end

  def birthday= value
    if value.is_a? String
      begin
        value = Date.parse(value)
      rescue Exception => e
        value = nil
      end
    end

    super
  end

  def email_changed?
    encrypted_email_changed?
  end

  def self.find_for_authentication(tainted_conditions)
    User.find_by_email(tainted_conditions[:email])
  end

  def email_was
    User.decrypt_email(encrypted_email_was)
  end

  # def birthday
  #   if super
  #     super.strftime('%d/%m/%Y')
  #   end
  # end

  def gender= value
    [0, 1, 2, 3].each do |i|
      if value == i.to_s
        value = i
      end
    end
    super
  end

  def cycles_interacted
    Cycle.where(
      id: PluginRelation.where(
        id: Subject.where(
          id: Comment.where(
            id: (
              [self.comments.pluck(:id)] +
              [self.likes.pluck(:comment_id)] +
              [self.dislikes.pluck(:comment_id)])
            ).pluck(:subject_id)
          ).pluck(:plugin_relation_id)
        ).map { |x| x.cycle.id }
      )
  end

  def interactions

  end

  def anonymous_interactions
    self.comments.where(is_anonymous: true)
  end

  def ensure_session_token_for platform
    destroy_latest_token platform

    self.session_tokens.create! platform: platform
  end

  def latest_token_for platform
    session_tokens.valid_for(platform).first
  end

  def destroy_latest_token platform
    token = latest_token_for platform

    if token
      token.destroy!
    end
  end

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)
    omniauth_identity = OmniauthIdentity.find_for_oauth(auth)

    user = signed_in_resource ? signed_in_resource : omniauth_identity.user
    user ||= User.where(email: auth['info']['email']).first_or_initialize

    if user.persisted?
      if omniauth_identity.new_record?
        omniauth_identity.user = user
        omniauth_identity.save
      end
    else
      user.assign_attributes(
        name: auth['info']['name']
      )

      user.omniauth_identities = [omniauth_identity]
    end

    user
  end

  # def self.find_for_oauth(auth, signed_in_resource = nil)

  #   # Get the identity and user if they exist
  #   omniauth_identity = OmniauthIdentity.find_for_oauth(auth)

  #   # If a signed_in_resource is provided it always overrides the existing user
  #   # to prevent the identity being locked with accidentally created accounts.
  #   # Note that this may leave zombie accounts (with no associated identity) which
  #   # can be cleaned up at a later date.
  #   user = signed_in_resource ? signed_in_resource : omniauth_identity.user

  #   # Create the user if needed
  #   if user.nil?

  #     # Get the existing user by email if the provider gives us a verified email.
  #     # If no verified email was provided we assign a temporary email and ask the
  #     # user to verify it on the next step via UsersController.finish_signup
  #     email = auth.info.email
  #     user = User.where(:email => email).first if email

  #     # Create the user if it's a new registration
  #     if user.nil?
  #       password = Devise.friendly_token[0,20]
  #       user = User.new(
  #           name: auth.extra.raw_info.name,
  #           #username: auth.info.nickname || auth.uid,
  #           email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
  #           password: password,
  #           password_confirmation: password
  #       )
  #       #user.skip_confirmation! # If using confirmable skips the confirmation email
  #       user.save!
  #     end
  #   end

  #   # Associate the identity with the user if needed
  #   if omniauth_identity.user != user
  #     omniauth_identity.user = user
  #     omniauth_identity.save!
  #   end
  #   user
  # end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def all_attributes
    h = super - ['picture_updated_at',
      'picture_file_size',
      'picture_content_type',
      'picture_file_name',
      'encrypted_password',
      'reset_password_token',
      'reset_password_sent_at',
      'remember_created_at',
      'sign_in_count',
      'current_sign_in_at',
      'last_sign_in_at',
      'current_sign_in_ip',
      'last_sign_in_ip',
      'deleted_at',
      'created_at',
      'updated_at',
      'profile_id',
      'sub_profile_id'
    ]
    h.push("picture")
    h.push('anonymous_picture_url')
    h.push('profile')
    h.push('sub_profile')
    h
  end

  def self.to_csv
    CSV.generate(col_sep: "\t") do |csv|
      h = {
        id: "ID",
        email: "E-mail",
        name: "Nome",
        created_at: "Data de Criação",
        cpf: "CPF",
        birthday: "Data de Nascimento",
        gender: "Gênero",
        state: "Estado",
        city: "Cidade",
        profile: "Perfil",
        sub_profile: "Sub Perfil",
        comment_count: "Total de Comentários"
      }

      csv << h.values

      self.includes(:profile, :sub_profile, :comments).where(is_admin: false).each do |item|
        values = h.keys.map do |k|
          if [:profile, :sub_profile].include? k
            if item.send(k)
              item.send(k).name
            else
              nil
            end
          elsif k == :comment_count
            item.comments.count
          else
            item.send(k)
          end
        end

        csv << values
      end
    end
  end

  validates_attachment :picture, content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "image/jpg"] }, unless: -> { self.first_step }

  validates_presence_of :name
  validates_presence_of :birthday, unless: -> { self.is_admin }
  validates_presence_of :state, :city, :profile, :profile_id, :gender, unless: -> { self.first_step or self.is_admin }
  validates_presence_of :sub_profile,:sub_profile_id, unless: -> {(self.profile.nil? || self.profile.children_count == 0) or self.is_admin}

  validates_uniqueness_of :encrypted_alias_name, unless: -> { self.first_step or self.is_admin }

  validates :terms, acceptance: { accept: true }, unless: -> { self.first_step or self.is_admin }

  after_create :delete_alias_name, if: -> { self.alias_name }, unless: -> { self.is_admin }

  validates_presence_of :email, if: :email_required?
  validates_uniqueness_of :encrypted_email, allow_blank: true, if: :encrypted_email_changed?
  validates_format_of :email, with: Devise.email_regexp, allow_blank: true, if: :email_changed?

  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validates_length_of :password, within: Devise.password_length, allow_blank: true

  private

    def delete_alias_name
      AliasName.find_by_name(self.alias_name).destroy
    end

    def password_required?
      !persisted? || !password.nil? || !password_confirmation.nil?
    end

    def email_required?
      true
    end

end
