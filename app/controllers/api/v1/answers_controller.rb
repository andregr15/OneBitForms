class Api::V1::AnswersController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!, except: [:create]
  before_action :set_answer, only: [:show, :destroy]
  before_action :set_form
  before_action :allow_only_owner, only: [:index, :show, :destroy]

  def index
    @questions = @form.questions
    render json: @questions, include: 'questions_answers'
  end

  def show
    render json: @answer, include: 'questions_answers'
  end

  def create
    @answer = Answer.create_with_questions_answers(@form, params['questions_answers'])
    render json: @answer
  end

  def destroy
    @answer.destroy
    render json: { message: 'ok' }
  end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_form
      @form = (@answer) ? @answer.form : Form.find(params[:form_id])
    end

    def allow_only_owner
      unless current_api_v1_user == @form.user
        render(json: {}, status: :forbidden) and return
      end
    end
end
