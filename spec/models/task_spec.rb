require 'rails_helper'

RSpec.describe Task do
  let(:task) { build(:task) }

  describe 'associations' do
    it 'belongs to a project' do
      association = described_class.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    context 'when task is valid' do
      it 'passes validation' do
        expect(task).to be_valid
      end
    end

    context 'when task has no name' do
      let(:invalid_task) { build(:task, name: nil) }

      it 'fails validation' do
        expect(invalid_task).not_to be_valid
      end

      it 'returns an error message for name' do
        invalid_task.valid?
        expect(invalid_task.errors[:name]).to include("can't be blank")
      end
    end

    context 'when task status is invalid' do
      let(:invalid_task) { build(:task, status: Faker::Lorem.word) }

      it 'fails validation' do
        expect(invalid_task).not_to be_valid
      end

      it 'returns an error message for status' do
        invalid_task.valid?
        expect(invalid_task.errors[:status]).to include('is not included in the list')
      end
    end
  end

  describe 'enumerize' do
    it 'has the correct enumerize values' do
      expect(described_class.status.values).to eq(%i[new in_progress completed])
    end

    it 'has the correct default status' do
      task = described_class.new
      expect(task.status).to eq(:new)
    end
  end
end
