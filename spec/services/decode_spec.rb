# frozen_string_literal: true

require "rails_helper"

describe Decode, type: :service do
  subject(:service) { described_class.new(string) }
  
  describe "#call" do
    context "when string is empty" do
      let(:string) { nil }

      it do
        expect(service.call).to eq(0)
      end
    end

    context "when string is not empty" do
      let(:string) { "005aAc" }

      it do
        expect(service.call).to eq(1232324)
      end
    end
  end
end
