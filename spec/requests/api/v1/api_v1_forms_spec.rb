require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe 'GET /forms' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/forms'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
        @forms = []
        10.times do
          @forms << create(:form, user: @user)
        end

        get '/api/v1/forms', params: {}, headers: header_with_authentication(@user)
      end

      it 'should returns the http status 200' do
        # help method of module request_helper
        expect_status(200)
      end

      it 'should returns form list with 10 forms' do
        # json = help method of module request_helper
        expect(json.count).to eq(10)
      end

      it 'should returns the forms with right datas' do
        i = 0
        until i > @forms.length do
          expect(json[i]).to eql(JSON.parse(@forms[i].to_json))
          i += 1
        end
      end
    end
  end

  describe 'GET /forms/:friendly_id' do
    before do
      @user = create(:user)
    end

    context 'When the form exists' do
      context 'And is enable' do
        before do
          @form = create(:form, user: @user, enable: true)

          get "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should returns the form with the right data' do
          expect(json).to eql(JSON.parse(@form.to_json))
        end
      end

      context 'And is unable' do
        before do
          @form = create(:form, user: @user, enable: false)
        end

        it 'should returns the http status 404' do
          get '/api/v1/forms/', params: {id: @form.friendly_id}, headers: header_with_authentication(@user)
        end
      end
    end

    context 'When form do not exists' do
      it 'should returns the http status 404' do
        get "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
      end
    end
  end

  describe 'POST /forms' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/forms'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'And with valid params' do
        before do
          @form_attributes = attributes_for(:form)
          post '/api/v1/forms', params: { form: @form_attributes }, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should have created the form in the database with correct data' do
          form = Form.first
          @form_attributes.each do |field|
            expect(form[field.first]).to eql(field.last)
          end
        end

        it 'should have returned the correct data' do
          @form_attributes.each do |field|
            expect(json[field.first.to_s]).to eql(field.last)
          end
        end
      end

      context 'And with invalid params' do
        it 'should returns the http status 400' do
          post '/api/v1/forms', params: { form: {} }, headers: header_with_authentication(@user)
          expect_status(400)
        end
      end

    end
  end

  describe 'PUT /forms/:friendly_id' do
    
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/forms/questionary'
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'When form exists' do

        context 'And user is the owner of the form' do
          before do
            @form = create(:form, user: @user)
            @form_attributes = attributes_for(:form, id: @form.id)
            put "/api/v1/forms/#{@form.friendly_id}", params: { form: @form_attributes }, headers: header_with_authentication(@user)
          end

          it 'should returns the http status 200' do
            expect_status(200)
          end

          it 'should have update the form in the database with the correct data' do
            @form.reload
            @form_attributes.each do |field|
              expect(@form[field.first]).to eql(field.last)
            end
          end

          it 'should have returned the correct data' do
            @form_attributes.each do |field|
              expect(json[field.first.to_s]).to eql(field.last)
            end
          end
          
        end

        context 'And user is not the owner' do
          it 'should returns the http status 403' do
            form = create(:form)
            form_attributes = attributes_for(:form, id: form.id)
            put "/api/v1/forms/#{form.friendly_id}", params: { form: form_attributes }, headers: header_with_authentication(@user)
            expect_status(403)
          end
        end

      end

      context 'When the form do not exists' do
        it 'should returns the http status 404' do
          form_attributes = attributes_for(:form)
          put "/api/v1/forms/#{FFaker::Lorem.word}", params: { form: form_attributes }, headers: header_with_authentication(@user)
        end
      end

    end
  end


  describe 'DELETE /forms/:friendly_id' do
    before do
      @user = create(:user)
    end

    context 'When the form exists' do
      context 'And user is the owner of the form' do
        before do
          @form = create(:form, user: @user)
          delete "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
        end

        it 'should returns the http status 200' do
          expect_status(200)
        end

        it 'should have deleted the form from the database' do
          execpt(Form.all.count).to eql(0)
        end
      end

      context 'And the user is not the owner of the form' do
        it 'should returns the http status 403' do
          form = create(:form)
          delete "/api/v1/forms/#{form.friendly_id}", params: {}, headers: header_with_authentication(@user)

          expect_status(403)
        end        
      end

      context 'When the form do not exists' do
        it 'should returns the http status 404' do
          delete "/api/v1/forms/#{FFaker.Lorem.word}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end

  end

end
