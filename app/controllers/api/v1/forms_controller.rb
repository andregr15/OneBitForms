class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:show]
  before_action :set_form, only: [:show, :update, :destroy]
  before_action :allow_only_owner, only: [:update, :destroy]

  def index
    @forms = current_api_v1_user.forms
    render json: @forms.to_json
  end

  def show
    setQuestionsOrder()
    render json: @form, include: 'questions', order: 'order asc'
  end

  def update
    @form.update(form_params)
    render json: @form
  end

  def create
    @form = Form.create(form_params)
    
    if @form.errors.empty?
      render json: @form
    else
      render json: @form.errors, status: 403
    end
  end

  def destroy
    @form.destroy
    render json: @form
  end

  private
    def set_form
      @form = Form.friendly.find(params[:id])
    end

    def allow_only_owner
      unless current_api_v1_user == @form.user
        render(json: {}, status: :forbidden) and return
      end
    end

    def form_params
      params.require(:form).permit(:title, :description, :enable, :primary_color).merge(user: current_api_v1_user)
    end

    def setQuestionsOrder
      @form.questions.select { |q| q.order.nil? || q.order == 0}.each do |q|
        max = @form.questions.select { |q| !q.order.nil? && q.order != 0}.map(&:order).max
        q.order = max + 1
        q.update(order: q.order)
      end
    end
end
