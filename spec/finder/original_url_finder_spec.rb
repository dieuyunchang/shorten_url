# frozen_string_literal: true

require "rails_helper"

describe OriginalUrlFinder do
  subject(:finder) { described_class.new(short_code) }
  
  describe "#find" do
    context "when string is nil" do
      let(:short_code) { nil }

      it do
        expect(finder.find).to be_nil
      end
    end

    context "when string is an empty string" do
      let(:short_code) { "" }

      it do
        expect(finder.find).to be_nil
      end
    end

    context "when string is not empty" do
      let(:short_code) { Encode.new(123).call }

      context "when short_code doesn't exist" do
        it do
          expect(finder.find).to be_nil
        end
      end

      context "when short_code exist exist" do
        let(:original_url) { "http://google.com.vn/" }
        let(:shortened_url) { create(:shortened_url, original_url: original_url) }
        let(:short_code) { Encode.new(shortened_url.id).call}
        
        it do
          expect(finder.find).to eq(original_url)
        end
      end
    end
  end
end
