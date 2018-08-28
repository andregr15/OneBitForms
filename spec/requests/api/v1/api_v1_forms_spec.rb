require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /api_v1_forms" do
    it "works! (now write some real specs)" do
      get api_v1_forms_index_path
      expect(response).to have_http_status(200)
    end
  end
end
