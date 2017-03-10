class UserService
  attr_accessor :password_generator

  Result = Struct.new(:user, :password, :success)

  # @param password_generator [#friendly_token]
  def initialize(password_generator: Devise)
    @password_generator = password_generator
  end

  def create_user_with_auto_password(email: nil, name: nil)
    password = gen_password
    user = User.new(name: name, email: email, password: password)

    success = user.save

    Result.new(user, password, success)
  end

  private

  def gen_password
    password_generator.friendly_token.first(8)
  end
end
