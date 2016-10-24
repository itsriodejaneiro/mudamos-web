class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_cycles
  before_action :set_static_pages
  before_action :set_social_links
  before_action :get_notifications, if: -> { user_signed_in? }

  before_action :create_comment, if: -> { user_signed_in? and cookies[:new_comment_content].present? }
  before_action :clear_cookies, if: -> { user_signed_in? }

  before_action :set_user, if: -> { cookies[:omniauth_auth].present? and not user_signed_in? }

  def send_csv data, filename
    send_data(
      data.encode('UTF-8', invalid: :replace, undef: :replace, replace: "?"),
      type: 'text/csv; charset=iso-8859-1; header=present',
      disposition: "attachment; filename=#{filename}.csv"
    )
  end

  private

    def set_cycles
      @cycles = Cycle.all
    end

    def set_social_links
      @social_links = SocialLink.all
    end

    def set_static_pages
      @header_pages = StaticPage.where(show_on_header: true)
      @footer_pages = StaticPage.where(show_on_footer: true)
    end

    def get_notifications
      @notifications = InternalNotification.where(notification_id: current_user.notifications.pluck(:id))
    end

    def create_comment
      if cookies[:cycle].present? and cookies[:subject].present?
        begin
          @cycle = Cycle.find cookies[:cycle]
          @subject = @cycle.subjects.find cookies[:subject]

          @comment = @subject.comments.new(
            content: cookies[:new_comment_content],
            parent_id: cookies[:new_comment_parent_id],
            is_anonymous: cookies[:new_comment_is_anonymous]
          )
          @comment.user = current_user

          if @comment.save
            flash.now[:success] = "Comentário enviado com sucesso."
          else
            flash.now[:error] = "Não foi possível criar seu comentário."
          end
        rescue Exception => e
          clear_cookies
        end
      end
    end

    def clear_cookies
      [:user_photo, :omniauth_identity, :omniauth_auth].each do |attr|
        session.delete(attr)
      end

      [
        :new_comment_content,
        :new_comment_is_anonymous,
        :new_comment_parent_id,
        :controller,
        :action,
        :cycle,
        :subject,
        :after_login_path
      ].each do |attr|
        cookies.delete(attr)
      end
    end

    def set_user
      begin
        cookies[:user_photo] = { value: HTTParty.get(JSON.parse(cookies[:omniauth_auth])['info']['image']).request.path.to_s, expires: 5.minutes.from_now}

        @user = User.find_for_oauth(JSON.parse(cookies.delete(:omniauth_auth)))

        cookies[:omniauth_identity] = { value: @user.omniauth_identities.first.attributes.to_json, expires: 5.minutes.from_now }
      rescue Exception => e
        clear_cookies
      end
    end

end
