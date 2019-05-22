class Admin::FaqsController < Admin::ApplicationController
  def index
    @faqs = Faq.all
  end

  def show
    @faq = Faq.find params[:id]
  end

  def new
    @faq = Faq.new(sequence: Faq.count)
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  def create
    @faq = Faq.new faq_params
    @faq.admin_user = current_admin_user

    if @faq.save
      @faq.insert_at_sequence(@faq.sequence)
      flash[:success] = "FAQ criado com sucesso."
      redirect_to [:admin, @faq]
    else
      flash[:error] = "Ocorreu algum erro ao criar o FAQ."
      render :new
    end
  end

  def update
    @faq = Faq.find(params[:id])
    @faq.assign_attributes faq_params

    if @faq.sequence_changed?
      @faq.insert_at_sequence(faq_params["sequence"].to_i)
    end

    if @faq.save
      flash[:success] = "FAQ atualizado com sucesso."

      fast_updated = @faq.published_changed?

      if fast_updated
        redirect_to request.referrer
      else
        redirect_to [:admin, @faq]
      end
    else
      flash[:error] = "Ocorreu algum erro ao atualizar o FAQ."
      render :edit
    end
  end

  def destroy
    @faq = Faq.find(params[:id])

    if @faq.destroy
      flash[:success] = "FAQ apagado com sucesso."
    else
      flash[:error] = "Ocorreu algum erro ao apagar o FAQ."
    end
    redirect_to [:admin, :faqs]
  end

  private

    def faq_params
      params.require(:faq).permit(
        :title,
        :content,
        :sequence,
        :user_id,
        :published,
      )
    end
end
