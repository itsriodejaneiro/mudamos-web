class UserAccountSync
  def perform(user)
    send_message user
  end

  private

  def send_message(user)
    payload = payload(user)

    sqs = Aws::SQS::Client.new

    queue_url = sqs.get_queue_url(queue_name: ENV["USER_SYNC_QUEUE"])
    sqs.send_message(
      queue_url: queue_url.queue_url,
      message_body: JSON.generate(payload)
    )
  end

  def payload(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      profile: user.profile.name,
      gender: user.gender,
      birthday: user.birthday.strftime("%Y-%m-%d"),
      picture_url: user.picture.url,
      password: user.encrypted_password,
      cpf: user.cpf
    }
  end
end
