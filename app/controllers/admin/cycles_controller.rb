class Admin::CyclesController < Admin::ApplicationController
  before_action :admin_must_be_master!,  only: [:new, :create, :edit, :update, :destroy]

  def index
    @cycles = Cycle.all
  end

  def show
    @cycle=Cycle.find(params[:id])
    if params[:start_date]
      range_start = DateTime.parse(params[:start_date]).beginning_of_day
    else
      range_start = 1.week.ago.beginning_of_day
      params[:start_date] = range_start
    end

    if params[:end_date]
      range_end = DateTime.parse(params[:end_date]).end_of_day
    else
      range_end = Time.zone.now.end_of_day
      params[:end_date] = range_end
    end

    if params[:start_month]
      range_month_start = DateTime.parse(params[:start_month]).beginning_of_month
    else
      range_month_start = DateTime.new(2015,10,01)
      params[:start_month] = range_month_start
    end

    if params[:end_month]
      range_month_end = DateTime.parse(params[:end_month]).end_of_month
    else
      range_month_end = Time.zone.now.end_of_month
      params[:end_month] = range_month_end
    end

    @user_profile_count_in_range = @cycle.user_profile_count_in_range(range_start, range_end)

    @user_profile_month_count_in_range = @cycle.user_profile_count_in_range(range_month_start, range_month_end, true)
    # @user_count_in_range = @cycle.user_count_in_range(range_start, range_end)

    @comment_profile_count_in_range  = @cycle.comment_profile_count_in_range(range_start, range_end)

    @comment_profile_month_count_in_range = @cycle.comment_profile_count_in_range(range_month_start, range_month_end, true)

    # @comment_count_in_range  = @cycle.comment_count_in_range(range_start, range_end)
  end

  def new
    if Rails.env.production?
      @cycle = Cycle.new
    else
      @cycle = Cycle.new(
        title: 'Tema teste 1',
        description: 'Continually strategize clicks-and-mortar mindshare whereas extensive mindshare. Dramatically predominate emerging customer service with covalent deliverables. Efficiently.',
        color: '#247102',
        picture: File.open("#{Rails.root}/app/assets/images/Escada.jpg", "r"),
        phases: [
          Phase.new(
            name: 'Fase 1 do Tema 1',
            description: 'Bla bla bla bla essa é uma descrição',
            initial_date: Time.zone.now - 1.day,
            final_date: Time.zone.now + 1.day,
            plugin_relation: PluginRelation.new(plugin: Plugin.find(1))
          )
        ],
        plugins: [Plugin.find(3)]
      )
    end
  end

  def create
    @cycle = Cycle.new cycle_params
    @cycle.phases.map do |x|
      x.cycle = @cycle
      x.plugin_relation.related = x
    end

    @cycle_plugin_relations = params[:cycle][:plugin_ids].reject { |x| x.blank? }.map do |id|
      PluginRelation.new(related: @cycle, plugin: Plugin.find(id))
    end

    @cycle.plugin_relations = @cycle_plugin_relations

    if @cycle.save
      flash[:success] = "Ciclo criado com sucesso."
      redirect_to [:admin, @cycle]
    else
      flash[:error] = "Erro ao criar Ciclo."
      render :new
    end
  end

  def edit
    @cycle = Cycle.find params[:id]
  end

  def update
    @cycle = Cycle.find params[:id]
    @cycle.assign_attributes(cycle_params)

    @cycle.phases.map do |x|
      x.cycle = @cycle
      x.plugin_relation.related = x
    end

    # @cycle_plugin_relations = params[:cycle][:plugin_ids].reject { |x| x.blank? }.map do |id|
    #   PluginRelation.where(related: @cycle, plugin: Plugin.find(id)).first_or_initialize
    # end

    # @cycle.plugin_relations = @cycle_plugin_relations

    if @cycle.save
      flash[:success] = "Ciclo atualizado com sucesso."
      redirect_to [:admin, @cycle]
    else
      flash[:error] = "Erro ao atualizar ciclo."
      render :edit
    end
  end

  private

    def cycle_params
      params.require(:cycle).permit(
        :title,
        :description,
        :color,
        :picture,
        phases_attributes: [
          :id,
          :name,
          :description,
          :initial_date,
          :final_date,
          :_destroy,
          plugin_relation_attributes: [
            :id,
            :plugin_id
          ]
        ]
      )
    end
end
