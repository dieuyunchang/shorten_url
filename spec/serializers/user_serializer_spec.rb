# frozen_string_literal: true

require "rails_helper"

describe UserSerializer do
  subject(:serialized_resource) { described_class.new(user) }
  let(:user) { create(:user) }
  
  it { expect(serialized_resource.as_json).to have_key(:id) }
  it { expect(serialized_resource.as_json).to have_key(:email) }
end
