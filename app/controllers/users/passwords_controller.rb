class Users::PasswordsController < Devise::PasswordsController
  respond_to :js

  def create
    self.resource = User.find_by_email(params[:user][:email])

    if resource.present? and resource.persisted?
      resource.send_reset_password_instructions
      yield resource if block_given?

      @success = successfully_sent?(resource)
      if @success
        flash[:success] = "E-mail enviado com sucesso."
        # respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        # respond_with(resource)
        flash[:error] = "Ocorreu algum erro."
      end
    else
      self.resource = User.new email: params[:user][:email]
      self.resource.errors.add :email, 'não encontrado.'
      flash[:error] = "Ocorreu algum erro."
    end

  end

  def edit
    @reset_password_user = resource_class.new
    # set_minimum_password_length
    @reset_password_user.reset_password_token = params[:reset_password_token]

    @highlights = GridHighlight.order('id ASC').all

    render 'cycles/index'
  end

  def update
    # binding.pry

    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      flash[:success] = "Senha atualizada com sucesso."
      sign_in(resource_name, resource)

      # resource.unlock_access! if unlockable?(resource)
      # if Devise.sign_in_after_reset_password
      #   flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      #   set_flash_message(:notice, flash_message) if is_flashing_format?
      #   sign_in(resource_name, resource)
      # else
      #   set_flash_message(:notice, :updated_not_active) if is_flashing_format?
      # end
      # respond_with resource, location: after_resetting_password_path_for(resource)
    else
      flash[:error] = "Ocorreu algum erro."
      # respond_with resource
    end
  end
end
