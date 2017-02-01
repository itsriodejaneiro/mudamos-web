class UserService
  def create_user_with_password(email:, name:, encrypted_password:)
    user = User.new(name: name, email: email, password: encrypted_password)
    
    if user.save
      user.update_attribute :encrypted_password, encrypted_password
    end

    user
  end
end
