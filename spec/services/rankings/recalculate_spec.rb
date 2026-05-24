# frozen_string_literal: true

require 'rails_helper'

describe Rankings::Recalculate do
  describe '.call' do
    it 'runs tip points, user points and ranking per game in a transaction' do
      expect(Tips::UpdatePoints).to receive(:call).ordered
      expect(Users::UpdatePoints).to receive(:call).ordered
      expect(Users::UpdateRankingPerGame).to receive(:call).ordered

      described_class.call
    end
  end
end
