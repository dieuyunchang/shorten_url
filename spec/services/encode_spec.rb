# frozen_string_literal: true

require "rails_helper"

describe Encode, type: :service do
  subject(:service) { described_class.new(number) }
  
  describe "#call" do
    context "when number is zero" do
      let(:number) { 0 }

      it do
        expect(service.call).to be_falsey
      end
    end

    context "when string is nil" do
      let(:number) { nil }

      it do
        expect(service.call).to be_falsey
      end
    end

    context "when string is not empty" do
      let(:number) { 1232324 }

      it do
        expect(service.call).to eq("5aAc")
      end
    end
  end
end
