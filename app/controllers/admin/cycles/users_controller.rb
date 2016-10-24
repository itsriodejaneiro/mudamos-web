class Admin::Cycles::UsersController < Admin::ApplicationController
  def index
    @users = Kaminari.paginate_array(@cycle.users.sort_by { |x| x.name }).page(params[:page]).per(qty)

    respond_to do |format|
      format.html  { }
      format.csv   { send_csv @cycle.users.to_csv, "usuarios" }
    end
  end

  def show
    @user = @cycle.users.find params[:id]
    # @cycles = @user.cycles_interacted.page(params[:page]).per(qty)

    params[:order] ||= 'created_at'
    @comments = @cycle.comments.where(user_id: @user.id).order("#{params[:order]} DESC").page(params[:page]).per(qty)
  end

  def user_comment_csv
    user = User.find params[:id]
    @comments = user.comments

    respond_to do |format|
      format.csv { send_csv @comments.to_csv, "comentarios" }
    end
  end
end
