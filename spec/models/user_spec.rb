# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context "validations" do
    it { is_expected.to validate_presence_of(:email) }
  end
end