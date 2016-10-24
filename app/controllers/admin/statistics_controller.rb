class Admin::StatisticsController < Admin::ApplicationController
  def index

  end

  def users_csv
    @users = User.all

    respond_to do |format|
      format.csv { send_csv @users.to_csv, "usuarios" }
    end
  end

  def comments_csv
    @comments = Comment.all

    respond_to do |format|
      format.csv { send_csv @comments.to_csv, "comentarios" }
    end
  end

end
