# frozen_string_literal: true

require 'rails_helper'

describe Team do
  it 'uses Factory' do
    team = create(:team)
    expect(team.name).to be_present
  end

  describe 'football_data_tla uniqueness' do
    it 'allows nil for many teams' do
      create(:team, football_data_tla: nil)
      expect { create(:team, football_data_tla: nil) }.not_to raise_error
    end

    it 'rejects a duplicate non-nil TLA' do
      create(:team, football_data_tla: 'GER')
      duplicate = build(:team, football_data_tla: 'GER')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:football_data_tla]).to be_present
    end
  end
end
