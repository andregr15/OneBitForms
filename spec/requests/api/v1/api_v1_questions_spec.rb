require 'rails_helper'

RSpec.describe "Api::V1::Questions", type: :request do

  describe 'POST /questions' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/questions'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'And with valid params' do
        before do
          @form = create(:form, user: @user)
          @question_attributes = attributes_for(:question)
          post '/api/v1/questions', params: { question: @question_attributes, form_id: @form.id }, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should have created the question in the database with the correct data' do
          question = Question.first
          @question_attributes.each do |field|
            expect(question[field.first]).to eql(field.last)
          end
        end

        it 'should have returned the correct data of the created question' do
          @question_attributes.each do |field|
            expect(json[field.first.to_s]).to eql(field.last)
          end
        end

      end

      context 'And with invalid params' do
        context 'with a valid form' do
          it 'should returns the http status 400' do
            form = create(:form, user: @user)
            post '/api/v1/questions', params: { question: {}, form_id: form.id }, headers: header_with_authentication(@user)
            expct_status(400)
          end

          context 'with an invalid form' do
            it 'should returns the http status 400' do
              post '/api/v1/questions', params: { question: {} }, headers: header_with_authentication(@user)
              expect_status(400)
            end
          end
        end
        
      end

    end

  end

  describe  'PUT /questions/:id' do

    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/questions/0'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'When question exists' do
        
        context 'And the user is the form owner' do
          before do
            @form = create(:form, user: @user)
            @question = create(:question, form: @form)
            @question_attributes = attributes_for(:question, id = @question.id)
            put "/api/v1/questions/#{@question.id}", params: { question: @question_attributes }, headers: header_with_authentication(@user)
          end

          it 'should returns the http status 200' do
            expect_status(200)
          end

          it 'should have updated the question in hte database with the correct data' do
            @question.reload
            @question_attributes.each do |field|
              expect(@question[field.first]).to eql(field.last)
            end
          end

          it 'should returns the correct data of the updated question' do
            @question_attributes.each do |field|
              expect(json[field.firts.to_s]).to eql(field.last)
            end
          end
        end

        context 'And user is not the form owner' do
          it 'should returns the http status 403' do
            question = create(:question)
            question_attributes = attributes_for(:question, id: question.id)
            put "/api/v1/question/#{@question.id}", params: { question: question_attributes }, headers: header_with_authentication

            expect_status(403)
          end
        end

      end

      context 'When question do not exists' do
        it 'should returns the http status 404' do
          quetion_attributes = attributes_for(:question)
          put '/api/v1/questions/0', params: { question: question_attributes }, headers: header_with_authentication(@user)

          expect_status(404)
        end
      end

    end

  end

  describe 'DELETE /questions/:id' do
    before do
      @user = create(:user)
    end

    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :delete, '/api/v1/questions/0'
    end

    context 'With valid authentication headers' do

      context 'When the question exists' do

        context 'And user is the form owner' do
          before do
            @form = create(:form, user: @user)
            @question = create(:question, form: @form)
            delete "/api/v1/questions/#{@question.id}", params: {}, headers: header_with_authentication(@user)
          end

          it 'should returns the http status 200' do
            expect_status(200)
          end

          it 'should have deleted the question in the database' do
            expect(Question.all.count).to eql(0)
          end
        end

        context 'And user is not the form owner' do
          it 'should returns the http status 403' do
            question = create(:question)
            delete "/api/v1/questions/#{question.id}", param: {}, headers: header_with_authentication(@user)

            expect_status(403)
          end
        end

      end

      context 'When question do not exists' do
        it 'should returns the http status 404' do
          delete '/apai/v1/questions/0', params: {}, header_with_authentication(@user)
          expect_status(404)
        end
      end

    end

  end

end
