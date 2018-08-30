require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  
  describe 'GET /answers' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
        @form = create(:form, user: @user)
        @answer1 = create(:answer, form: @form)
        @answer2 = create(:answer, form: @form)
        get '/api/v1/answers', params: { form_id: @form.id }, headers: header_with_authentication(@user)
      end

      it 'should returns the http status 200' do
        expect_status(200)
      end

      it 'should returns a list with the two answers created previously' do
        expect(json.count).to eql(2)
      end

      it 'should returns the answers with the correct datas' do
        expect(json[0].except('questions_answers')).to eql(JSON.parse(@answer1.to_json))
        expect(json[1].except('questions_answers')).to eql(JSON.parse(@answer2.to_json))
      end

    end

  end

  describe 'GET /answers/:id' do

    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers/0'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'When the answer exists' do
        before do  
          @form = create(:form, user: @user)
          @answer = create(:answer, form: @form)
          @questions_answer_1 = create(:questions_answer, answer: @answer)
          @questions_answer_2 = create(:questions_answer, answer: @answer)
          get "/api/v1/answers/#{@answer.id}", params: {}, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should have returned the answer with the correct data' do
          expect(json.except('questions_answers')).to eql(JSON.parse(@answer.to_json))
        end

        it 'should have returned the associated questions_answers' do
          expect(json['questions_answers'].first).to eql(JSON.parse(@questions_answer_1.to_json))
          expect(json['questions_answers'].last).to eql(JSON.parse(@questions_answer_2.to_json))
        end
      end

      context 'When the answer do not exists' do
        it 'should returns the http status 404' do
          get "/api/v1/answers/#{rand(0..9999)}", params: {}, headers: header_with_authentication(@user)
        end
      end

    end
  end

  describe 'POST /answers' do

   context 'And with valid form id' do
      before do
        @user = create(:user)
        @form = create(:form, user: @user)
        @question = create(:question, form: @form)
        @questions_answers_1_attributes = attributes_for(:questions_answer, question_id: @question.id)
        @questions_answers_2_attributes = attributes_for(:questions_answer, question_id: @question.id)
        post '/api/v1/answers', params: {
          form_id: @form.id, questions_answers: [
            @questions_answers_1_attributes,
            @questions_answers_2_attributes
          ],
          headers: header_with_authentication(@user)
        }
      end

      it 'should returns the http status 200' do
        expect_status(200)
      end

      it 'should have associated the answer with the correct form' do
        expect(@form).to eql(Answer.last.form)
      end

      it 'should have associated the questions_answers to the answer' do
        expect(json['id']).to eql(QuestionsAnswer.first.answer.id)
        expect(json['id']).to eql(QuestionsAnswer.last.answer.id)
      end
    end

    context 'And with invalid form id' do
      it 'should returns the http status 404' do
        @user = create(:user)
        post '/api/v1/answers', params: { form_id: 0 }, headers: header_with_authentication(@user)
        expect_status(404)
      end
    end

  end

  describe 'DELETE /answers/:id' do

    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :delete, '/api/v1/answers/questionary'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)         
      end

      context 'And user is the form owner' do
        before do
          @form = create(:form, user: @user)
          @answer = create(:answer, form: @form)
          @questions_answer = create(:questions_answer, answer: @answer)

          delete "/api/v1/answers/#{@answer.id}", params: {}, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should have deleted the answer in the database' do
          expect(Answer.all.count).to eql(0)
        end

        it 'should have delete the associated questions_answers' do
          expect(QuestionsAnswer.all.count).to eql(0)
        end
      
      end

      context 'And user is not the owner' do
        it 'should returns the http status 403' do
          answer = create(:answer)
          delete "/api/v1/answers/#{answer.id}", params: {}, headers: header_with_authentication(@user)
          expect_status(403)
        end
      end

      context 'When the answer do not exists' do
        it 'should returns the http status 404' do
          delete "/api/v1/answers/#{rand(0..9999)}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end

    end

  end

end