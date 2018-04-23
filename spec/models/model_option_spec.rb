require 'rails_helper'

RSpec.describe ModelOption, type: :model do
  describe 'model option association already exists' do
    it 'is invalid' do
      model = create :model_with_option
      option = model.options.first
      expect {
        model.options << option
      }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
