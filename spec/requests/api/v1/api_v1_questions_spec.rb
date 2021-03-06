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
            expect_status(400)
          end

          context 'with an invalid form' do
            it 'should returns the http status 404' do
              post '/api/v1/questions', params: { question: {} }, headers: header_with_authentication(@user)
              expect_status(404)
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
            @question_attributes = attributes_for(:question, id: @question.id)
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
              expect(json[field.first.to_s]).to eql(field.last)
            end
          end
        end

        context 'And user is not the form owner' do
          it 'should returns the http status 403' do
            question = create(:question)
            question_attributes = attributes_for(:question, id: question.id)
            put "/api/v1/questions/#{question.id}", params: { question: question_attributes }, headers: header_with_authentication(@user)

            expect_status(403)
          end
        end

      end

      context 'When question do not exists' do
        it 'should returns the http status 404' do
          question_attributes = attributes_for(:question)
          put '/api/v1/questions/0', params: { question: question_attributes }, headers: header_with_authentication(@user)

          expect_status(404)
        end
      end

    end

  end

  describe 'PATCH /questions' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :patch, '/api/v1/questions'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'When the questions exists' do

        context 'And the user is the form owner' do
          before do
            @form = create(:form, user: @user)
            @questions_order = []
            5.times do
              question = create(:question, form: @form)
              @questions_order << { question_id: question.id, question_order: rand(1..999) }
            end
            
            patch '/api/v1/questions', params: { questions_order: @questions_order, form_id: @form.id }, headers: header_with_authentication(@user)
          end

          it 'should returns the http status 200' do
            expect_status(200)
          end

          it 'should have updated the questions order in database' do
            @questions_order.each do |qo|
              expect(Question.find(qo[:question_id]).order).to eq(qo[:question_order])
            end
          end

        end

        context 'And the user is not the form owner' do
          it 'should return the http status 403' do
            question = create(:question)
            question_order = [{ question_id: question.id, question_order: rand(1..999) }]
            
            patch '/api/v1/questions', params: { questions_order: question_order, form_id: question.form.id }, headers: header_with_authentication(@user)

            expect_status(403)
          end
        end

      end

      context 'When the questions do not exists' do
        it 'should return the http status 404' do
          question_order = [{ question_id: rand(1..999), question_order: rand(1..10) }]
          patch '/api/v1/questions', params: { questions_order: question_order, form_id: rand(1..10) }, headers: header_with_authentication(@user)
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
            delete "/api/v1/questions/#{question.id}", params: {}, headers: header_with_authentication(@user)

            expect_status(403)
          end
        end

      end

      context 'When question do not exists' do
        it 'should returns the http status 404' do
          delete '/api/v1/questions/0', params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end

    end

  end

end
