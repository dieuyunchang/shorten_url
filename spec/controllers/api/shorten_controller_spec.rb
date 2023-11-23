# frozen_string_literal: true

require "rails_helper"
describe Api::ShortenController, type: :controller do

  describe "#create" do
    context "when original_url is invalid" do
      let(:original_url) { "googlecom" }

      before do
        process :create, method: :post, params: { original_url: original_url }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it do
        error = JSON.parse(response.body)["error"]
        expect(error).to eq(["Original url is invalid"])
      end
    end

    context "when something wrong on CreateShortenLink service" do
      let(:original_url) { "https://google.com" }
      let(:service_error) { instance_double(ActiveModel::Errors, full_messages: ["Something went wrong"]) }

      before do
        allow(CreateShortenLink).to receive(:call).with(original_url).and_return(CreateShortenLink.create_result(successful?: false, errors: service_error))

        process :create, method: :post, params: { original_url: original_url }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it do
        error = JSON.parse(response.body)["error"]
        expect(error).to eq(["Something went wrong"])
      end
    end

    context "when original_url is valid" do
      let(:original_url) { "https://google.com" }

      before do
        process :create, method: :post, params: { original_url: original_url }
      end

      it { expect(response).to have_http_status(:created) }
    end
  end
end
  