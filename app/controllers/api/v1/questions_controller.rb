class Api::V1::QuestionsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_question, only: [:update, :destroy]
  before_action :set_form
  before_action :allow_only_owner, only: [:create, :update, :destroy, :reorder]

  def create
    @question = Question.create(question_params.merge(form: @form))
    render json: @question
  end

  def update
    @question.update(question_params)
    render json: @question
  end

  def destroy
    @question.destroy
    render json: { message: 'ok' }
  end

  def reorder
    if(!reorder_params['questions_order'].nil?)
      reorder_params['questions_order'].each do |qa|
        question = Question.find(qa['question_id'].to_i)
        question.update(order: qa['question_order'].to_i)
      end
    end

      render json: { message: 'ok'}
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def set_form
      @form = (@question)? @question.form : Form.find(params[:form_id])
    end

    def allow_only_owner
      unless current_api_v1_user == @form.user
        render(json: {}, status: :forbidden) and return
      end
    end

    def question_params
      params.require(:question).permit(:title, :kind, :required, :order)
    end

    def reorder_params
      params.permit(:form_id, { questions_order: [:question_id, :question_order]})
    end
end
