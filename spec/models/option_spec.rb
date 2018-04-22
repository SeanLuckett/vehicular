require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'name' do
    it 'is invalid without' do
      option = build :option, name: nil
      option.valid?
      expect(option.errors[:name]).to include "can't be blank"
    end

    it 'must be unique' do
      existing_option = create :option
      option = build :option, name: existing_option.name.downcase

      option.valid?
      expect(option.errors[:name]).to include 'has already been taken'
    end
  end
end
