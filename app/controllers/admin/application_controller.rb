class Admin::ApplicationController < ActionController::Base
  before_action :authenticate_admin_user!
  before_action :set_cycle_and_plugins, if: -> { params[:cycle_id].present? }
  before_action :set_plugin_relation, if: -> { params[:plugin_relation_id].present? }
  before_action :set_static_pages, unless: -> { @cycle.present? }
  # http_basic_authenticate_with name: 'ITS', password: 'LiberdadePraDentroDaCabeca'

  def set_cycle_and_plugins
    @cycle = Cycle.find params[:cycle_id]
    @cycle_plugins = @cycle.plugin_relations
  end

  def set_plugin_relation
    @plugin_relation = @cycle.plugin_relations.find params[:plugin_relation_id]
  end

  def set_static_pages
    @static_pages = StaticPage.all
  end

  def qty
    if params[:qty].present?
      @qty = params[:qty]
    elsif params[:page_size].present?
      @qty = params[:page_size]
    end

    @qty || 10
  end

  def send_csv data, filename
    send_data(
      data.encode('UTF-8', invalid: :replace, undef: :replace, replace: "?"),
      type: 'text/csv; charset=iso-8859-1; header=present',
      disposition: "attachment; filename=#{filename}.csv"
    )
  end

  def admin_must_be_master!
    if admin_user_signed_in? and current_admin_user.Master?
      return
    else
      flash[:error] = "Você não pode acessar essa área."
      redirect_to :admin
    end
  end
end
