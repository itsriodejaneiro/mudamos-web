class Admin::Cycles::PluginRelations::SubjectsController < Admin::ApplicationController
  before_action :set_vocabulary_plugin_relation, only: [:new, :create, :edit, :update]
  def index
    @subjects = @plugin_relation.subjects.page(params[:page]).per(qty)
  end

  def show
    @subject = @plugin_relation.subjects.find params[:id]

    params[:order] ||= 'created_at'
    @comments = @subject.comments.order("#{params[:order]} DESC")

    @comment_profile_count_in_range = @comments.includes(:user, user: :profile).group_by { |x| x.user.profile.name }

    @comments = @comments.page(params[:page]).per(qty)
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = @plugin_relation.subjects.new subject_params

    if @subject.save
      flash[:success] = "Assunto criado com sucesso."
      redirect_to [:admin, @cycle, @plugin_relation, :subjects]
    else
      flash[:error] = "Ocorreu algum erro ao criar o assunto."
      render :new
    end
  end

  def edit
    @subject = @plugin_relation.subjects.find params[:id]
  end

  def update
    @subject = @plugin_relation.subjects.find params[:id]

    if @subject.update_attributes subject_params
      flash[:success] = "Assunto atualizado com sucesso."

      if subject_params[:file].present?
        redirect_to [:admin, @cycle, @cycle.plugin_relations.find('relatoria')]
      else
        redirect_to [:admin, @cycle, @plugin_relation, :subjects]
      end
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o assunto."

      if subject_params[:file].present?
        redirect_to [:admin, @cycle, @cycle.plugin_relations.find('relatoria')]
      else
        render :edit
      end
    end
  end

  def destroy
    @subject = @plugin_relation.subjects.find params[:id]

    if @subject.destroy
      flash[:success] = "Assunto apagado com sucesso."
    else
      flash[:error] = "Ocorreu algum erro ao apagar o assunto."
    end

    redirect_to [:admin, @cycle, @plugin_relation, :subjects]
  end

  private

    def set_vocabulary_plugin_relation
      @vocabulary_plugin_relation = @cycle.plugin_relations.find_by_slug('glossario')
    end

    def subject_params
      params.require(:subject).permit(
        :enunciation,
        :question,
        :title,
        :vocabulary_id,
        :tag_description,
        :file
      )
    end
end

