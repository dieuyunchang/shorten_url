# frozen_string_literal: true

require "rails_helper"
describe LinkController, type: :controller do
  describe "#index" do
    before do
      process :index, method: :get
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe "#show" do
    context "when short_code exist" do
      let(:short_code) { "A123" }
      let!(:shortened_url) { create(:shortened_url, short_code: short_code) }

      before do
        process :show, method: :get, params: { short_code: short_code }
      end
      
      it { expect(response).to redirect_to(shortened_url.original_url) }
    end

    context "when short_code does not exist" do
      let(:short_code) { "A123" }

      before do
        process :show, method: :get, params: { short_code: short_code }
      end
      
      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
