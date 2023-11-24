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
    let(:found_original_url) { nil }

    before do
      finder = OriginalUrlFinder.new(short_code)
      allow(OriginalUrlFinder).to receive(:new).with(short_code).and_return(finder)
      allow(finder).to receive(:find).and_return(found_original_url)
    end

    context "when short_code exist" do
      let(:short_code) { "A123" }
      let(:original_url) { "https://google.com" }
      let(:found_original_url) { original_url }

      before do
        process :show, method: :get, params: { short_code: short_code }
      end
      
      it { expect(response).to redirect_to(original_url) }
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
