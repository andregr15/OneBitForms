require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  describe "GET /api_v1_answers" do
    it "works! (now write some real specs)" do
      get api_v1_answers_index_path
      expect(response).to have_http_status(200)
    end
  end
end
