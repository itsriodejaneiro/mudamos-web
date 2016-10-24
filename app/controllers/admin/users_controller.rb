class Admin::UsersController < Admin::ApplicationController
  def index
    @users = Kaminari.paginate_array(User.all.sort_by { |x| x.name }).page(params[:page]).per(qty)

    respond_to do |format|
      format.html  { }
      format.csv   { send_csv User.all.to_csv, "usuarios" }
    end
  end

  def show
    @user = User.find params[:id]
    @cycles = @user.cycles_interacted.page(params[:page]).per(qty)
  end

  def user_comment_csv
    user = User.find params[:id]
    @comments = user.comments

    respond_to do |format|
      format.csv { send_csv @comments.to_csv, "comentarios" }
    end
  end
end
