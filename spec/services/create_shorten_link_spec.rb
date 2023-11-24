# frozen_string_literal: true

require "rails_helper"

describe CreateShortenLink, type: :service do
  subject(:service) { described_class.new(url) }
  
  describe "#call" do
    context "when url is nil" do  
      let(:url) { nil }

      it do
        result = service.call
        result.errors.full_messages
        expect(result.errors.full_messages).to eq(["Url can not be blank"])
      end
    end

    context "when url is an empty string" do
      let(:url) { "" }

      it do
        result = service.call
        result.errors.full_messages
        expect(result.errors.full_messages).to eq(["Url can not be blank"])
      end
    end

    context "when url is not empty" do
      context "when url existed" do
        let(:url) { "https://google.com" }
        let(:sanitize_url) { url.strip.downcase.gsub(/(https?:\/\/|(www\.))/, "") }
        let!(:shortened_url) { create(:shortened_url, sanitize_url: sanitize_url) }

        it do
          short_code = Encode.new(shortened_url.id).call
          shortened_link = service.call.shortened_link
          aggregate_failures do
            expect(shortened_link).to eq("#{ENV["HOST_URL"]}#{short_code}")
            expect(ShortenedUrl.count).to eq(1)
          end
        end
      end

      context "when url is not existed" do
        context "with url is valid" do
          let(:url) { "https://google.com" }
          
          it do
            result = service.call
            short_code = Encode.new(ShortenedUrl.last.id).call

            aggregate_failures do
              expect(result.errors).to be_blank
              expect(ShortenedUrl.count).to eq(1)
              expect(result.shortened_link).to eq("#{ENV["HOST_URL"]}#{short_code}")
            end
          end
        end

        context "with url is invalid" do
          let(:url) { "google" }
          
          it do
            result = service.call
  
            aggregate_failures do
              expect(result.errors.full_messages).to eq(["Original url is invalid"])
            end
          end
        end
      end
    end
  end
end
