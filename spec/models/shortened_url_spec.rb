# frozen_string_literal: true
require 'rails_helper'

describe ShortenedUrl, type: :model do
  subject(:shortened_url) { build(:shortened_url) }

  context "validations" do
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_presence_of(:sanitize_url) }
  end

  context "custom validations" do
    describe 'when creating' do
      context 'with original_url is invalid' do
        it do
          shortened_url = build(:shortened_url, original_url: 'google')
          shortened_url.valid?
          expect(shortened_url.errors[:original_url]).to include('is invalid')
        end
      end
    end
  end
end
