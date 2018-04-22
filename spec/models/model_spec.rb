require 'rails_helper'

RSpec.describe Model, type: :model do
  it 'is invalid without a name' do
    model = build :model, name: nil
    model.valid?
    expect(model.errors[:name]).to include "can't be blank"
  end

  it 'is invalid if combination name and year exist' do
    existing = create :model
    model = build :model,
                  name: existing.name.downcase, year: existing.year

    model.valid?
    expect(model.errors[:name]).to include 'has already been taken'
  end

  describe ':year validations' do
    it 'is invalid without a year' do
      model = build :model, year: nil
      model.valid?
      expect(model.errors[:year]).to include "can't be blank"
    end

    it 'is invalid if has non-numeral characters' do
      model = build :model, year: 'bla4'
      model.valid?
      expect(model.errors[:year]).to include 'is not a number'
    end

    it 'is invalid if not an integer' do
      model = build :model, year: '23.4'
      model.valid?
      expect(model.errors[:year]).to include 'must be an integer'
    end

    it 'is invalid if not 4 characters long' do
      model = build :model, year: '8675309'
      model.valid?
      expect(model.errors[:year])
        .to include 'is the wrong length (should be 4 characters)'
    end
  end
end
