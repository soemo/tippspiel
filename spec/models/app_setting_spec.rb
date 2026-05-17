# frozen_string_literal: true

require 'rails_helper'

describe AppSetting do
  describe 'validations' do
    it 'requires a key' do
      record = described_class.new(value: 'x')
      expect(record).not_to be_valid
      expect(record.errors[:key]).not_to be_empty
    end

    it 'enforces key uniqueness' do
      described_class.create!(key: 'test_key', value: '1')
      duplicate = described_class.new(key: 'test_key', value: '2')
      expect(duplicate).not_to be_valid
    end
  end

  describe '.bonus_answer_how_many_goals' do
    it 'returns nil when not set' do
      expect(described_class.bonus_answer_how_many_goals).to be_nil
    end

    it 'returns an Integer when set' do
      described_class.set_bonus_answer_how_many_goals(7)
      expect(described_class.bonus_answer_how_many_goals).to eq(7)
    end
  end

  describe '.bonus_answer_when_will_the_first_goal' do
    it 'returns nil when not set' do
      expect(described_class.bonus_answer_when_will_the_first_goal).to be_nil
    end

    it 'returns an Integer when set' do
      described_class.set_bonus_answer_when_will_the_first_goal(3)
      expect(described_class.bonus_answer_when_will_the_first_goal).to eq(3)
    end
  end

  describe '.set_bonus_answer_how_many_goals' do
    it 'creates a new record on first call' do
      expect { described_class.set_bonus_answer_how_many_goals(5) }
        .to change(described_class, :count).by(1)
    end

    it 'updates the existing record on subsequent calls (upsert)' do
      described_class.set_bonus_answer_how_many_goals(5)
      expect { described_class.set_bonus_answer_how_many_goals(9) }
        .not_to(change(described_class, :count))
      expect(described_class.bonus_answer_how_many_goals).to eq(9)
    end
  end

  describe '.set_bonus_answer_when_will_the_first_goal' do
    it 'creates a new record on first call' do
      expect { described_class.set_bonus_answer_when_will_the_first_goal(2) }
        .to change(described_class, :count).by(1)
    end

    it 'updates the existing record on subsequent calls (upsert)' do
      described_class.set_bonus_answer_when_will_the_first_goal(2)
      expect { described_class.set_bonus_answer_when_will_the_first_goal(4) }
        .not_to(change(described_class, :count))
      expect(described_class.bonus_answer_when_will_the_first_goal).to eq(4)
    end
  end
end
