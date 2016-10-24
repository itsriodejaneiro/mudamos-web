class Api::V1::ApplicationController < Api::V1::BaseController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :set_new_resource, only: [:new, :create]
  before_action :set_collection, only: [:index]
  around_action :undefined_filter, only: [:index, :show], if: -> { params[:filter].present? }

  def index
    self.collection = query_searched_collection
    self.collection = related_included_collection
    self.collection = paginated_collection

    status = 200

    if self.collection.empty?
      status = 204
    end

    render status: status, json: {
      model_instance_variable_plural => json_collection,
      page_size: @page_size,
      page: @page,
      total_pages: @total_pages
    }
  end

  def show
    unless self.resource.blank?
      render status: 200, json:{
        model_instance_variable_singular => json_resource
      }
    else
      render_404
    end
  end

  def new
    render status: 200, json:{
      model_instance_variable_singular => self.resource.filtered_attributes
    }
  end

  def create
    resource = self.resource.assign_attributes resource_create_params

    if self.resource.save
      render status: 201, json: {
        model_instance_variable_singular => json_resource
      }
    else
      render_422
    end
  end

  def edit
    if self.resource
      render status: 200, json: {
        model_instance_variable_singular => self.resource.filtered_attributes
      }
    else
      render_404
    end
  end

  def update
    resource = model_class.find_by_id(params[:id])

    if self.resource
      if self.resource.update_attributes resource_update_params
        render status: 200, json: {
          model_instance_variable_singular => json_resource
        }
      else
        render_422
      end
    else
      render_404
    end
  end

  def destroy
    if self.resource.blank?
      render status: 200, nothing: true
    else
      render_404
    end
  end

  def resource
    instance_variable_get("@#{model_instance_variable_singular}")
  end

  def resource= value
    instance_variable_set("@#{model_instance_variable_singular}", value)
  end

  def collection
    instance_variable_get("@#{model_instance_variable_plural}")
  end

  def collection= value
    instance_variable_set("@#{model_instance_variable_plural}", value)
  end

  private

    # RENDERING METHODS
    def json_collection
      collection.map do |r|
        get_hash_from_resource r
      end
    end

    def json_resource
      get_hash_from_resource self.resource
    end

    def get_hash_from_resource r
      basic_hash = r.filtered_attributes(params[:filter])

      params.keys.select { |x| x.to_s.match(/_attributes\z/) }.each do |k|
        relation = k.to_s[0..-12]

        if relation.pluralize == relation
          basic_hash[relation] = r.send(relation.to_sym).map { |x| { relation.singularize => x.filtered_attributes } }
        else
          basic_hash[relation] = r.send(relation.to_sym).filtered_attributes(params[k])
        end
      end

      basic_hash
    end

    # BASIC MODEL SETTING METHODS
    def model_with_id
      if @parent
        @parent.send(model_instance_variable_plural.to_sym).find params[:id]
      else
        model_class.find params[:id]
      end
    end

    def new_model
      if @parent
        @parent.send(model_instance_variable_plural.to_sym).new
      else
        model_class.new
      end
    end

    def all_models
      if @parent
        @parent.send(model_instance_variable_plural.to_sym)
      else
        model_class.all
      end
    end

    # BASIC MODEL NAMING METHODS
    def model_name
      self.class.to_s.split('::').last.underscore.split('_')[0..-2].map { |mn| mn.camelize }.join
    end

    def model_class
      model_name.singularize.constantize
    end

    def model_instance_variable_singular
      model_name.underscore.singularize
    end

    def model_instance_variable_plural
      model_name.underscore
    end

    def set_resource
      if params[:id]
        instance_variable_set("@#{model_instance_variable_singular}", model_with_id)
      end
    end

    def set_new_resource
      instance_variable_set("@#{model_instance_variable_singular}", new_model)
    end

    def set_collection
      instance_variable_set("@#{model_instance_variable_plural}", all_models)
    end

    # RENDERING METHODS
    def render_404
      render status: 404, json: {
        errors: {
          model_instance_variable_singular => {
            id: [
              t(:does_not_exist)
            ]
          }
        }
      }
    end

    def render_401
      render status: 401, json: {
        errors: {
          model_instance_variable_singular => {
            authorization: [
              t(:needs_authorization)
            ]
          }
        }
      }
    end

    def render_422
      render status: 422, json:{
        model_instance_variable_singular => {
          errors: self.resource.errors.messages
        }
      }
    end

    def undefined_filter
      begin
        yield
      rescue NoMethodError => e
        render status: 400, json:{
          model_name: {
            errors: {
              invalid_parameter: [
                e.to_s.split[2][1..-2]
              ]
            }
          }
        }
      end
    end

    # QUERY SEARCH METHODS
    def query_searched_collection
      query = params[:query]

      query_collection = collection

      if query.blank?
        query_collection
      else
        q = query.split('|')
        q.map! { |e| e.split(',') }
        q.map! { |e| "(#{e.join(' ')})" }
        q_s = q.join(' AND ')
        query_collection = query_collection.where(q_s)
      end

      query_collection
    end

    # RELATED MODELS ATTRIBUTES METHODS
    def related_included_collection
      collection_with_related = collection

      params.keys.select { |x| x.to_s.match(/_attributes\z/) }.each do |k|
        relation = k.to_s[0..-12]    # - "_attributes"

        collection_with_related.joins{ __send__(relation) }
      end
      collection_with_related
    end

    # PAGINATION
    def paginated_collection
      @page_size = (params[:page_size] || 10).to_i
      @page = (params[:page] || 0).to_i

      @total_pages = (collection.count / @page_size).ceil

      collection.offset(@page * @page_size).limit(@page_size)
    end

    # NESTED CONTROLLER METHODS
    def self.inherit_from *parents
      @parents = parents
    end

    def parent_finder
      @@parents.each do |parent_symbol|
        id = params["#{parent_symbol}_id"]

        if @parent
          @parent = @parent.send(parent_symbol.to_s.pluralize.to_sym).find id
        else
          @parent = parent_symbol.to_s.constantize.find id
        end

        instance_variable_set("@#{parent_symbol}", @parent)
      end
    end

  protected

    # STRONNG PARAMETERS
    def resource_create_params
      params.fetch(model_instance_variable_singular.to_sym).permit(resource.attributes_to_filter)
    end

    def resource_update_params
      params.fetch(model_instance_variable_singular.to_sym).permit(resource.attributes_to_filter)
    end

end
