require 'rails_helper'

RSpec.describe Project do
  let(:project) { build(:project) }

  describe 'associations' do
    it 'has many tasks' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    context 'when project is valid' do
      it 'passes validation' do
        expect(project).to be_valid
      end
    end

    context 'when project is invalid' do
      let(:no_name_project) { build(:project, name: nil) }

      it 'fails validation' do
        expect(no_name_project).not_to be_valid
      end

      it 'returns an error message for name' do
        no_name_project.valid?
        expect(no_name_project.errors[:name]).to include("can't be blank")
      end
    end
  end
end
