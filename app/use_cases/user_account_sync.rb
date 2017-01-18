# This use case sends the user data to the queue that the mobile platform api uses
# to "pre-register" the user on their database
#
class UserAccountSync
  attr_reader :sqs_service

  def initialize(sqs_service: AwsService::SQS.new)
    @sqs_service = sqs_service
  end

  def perform(user)
    raise ArgumentError.new("user is empty") unless user.present?

    payload = payload(user)
    sqs_service.publish_message ENV["USER_SYNC_QUEUE"], payload
  end

  private

  def payload(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      profile: user.profile.name,
      sub_profile: user.sub_profile.try(:name),
      gender: user.gender,
      birthday: user.birthday.strftime("%Y-%m-%d"),
      picture_url: user.picture.url,
      password: user.encrypted_password,
      cpf: user.cpf
    }
  end
end
