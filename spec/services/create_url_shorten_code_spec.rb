# frozen_string_literal: true

require "rails_helper"

describe CreateUrlShortenCode, type: :service do
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
      let(:url) { nil }

      it do
        result = service.call
        result.errors.full_messages
        expect(result.errors.full_messages).to eq(["Url can not be blank"])
      end
    end

    context "when url is not empty" do
      context "when url existed" do
        let(:url) { "https://google.com" }
        
        before do
          sanitize_url = url.strip.downcase.gsub /(https?:\/\/|(www\.))/, ""
          create(:shortened_url, sanitize_url: sanitize_url, short_code: "Abcdef")
        end

        it do
          shortened_link = service.call.shortened_link
          expect(shortened_link).to eq("http://localhost:3000/Abcdef")
        end
      end

      context "when url is not existed" do
        let(:url) { "https://google.com" }
        
        it do
          result = service.call
          short_code = ShortenedUrl.last.short_code

          aggregate_failures do
            expect(result.errors).to be_blank
            expect(ShortenedUrl.all.count).to eq(1)
            expect(result.shortened_link).to eq("http://localhost:3000/#{short_code}")
          end
        end
      end
    end
  end
end
