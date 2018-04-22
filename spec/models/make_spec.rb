require 'rails_helper'

RSpec.describe Make, type: :model do
  it 'is invalid without a name' do
    make = build :make, name: nil
    make.valid?
    expect(make.errors[:name]).to include "can't be blank"
  end

  it 'is invalid if name is taken' do
    existing_make = create :make
    bad_make = build :make, name: existing_make.name.downcase
    bad_make.valid?
    expect(bad_make.errors[:name]).to include 'has already been taken'
  end
end
