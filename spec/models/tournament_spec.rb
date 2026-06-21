# frozen_string_literal: true

require 'rails_helper'

describe Tournament do
  subject { described_class }

  describe '#started?' do
    context 'if first game is in the future' do
      it 'returns false' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.from_now)

        expect(subject.started?).to be false
      end
    end

    context 'if first game is not in the future' do
      it 'returns true' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.ago)

        expect(subject.started?).to be true
      end
    end
  end

  describe '#round_of_16_not_yet_started?' do
    context 'if first game is in the future' do
      it 'returns true' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.from_now, round: ROUND_OF_16)

        expect(subject.round_of_16_not_yet_started?).to be true
      end
    end

    context 'if first game is not in the future' do
      it 'returns false' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.ago, round: ROUND_OF_16)

        expect(subject.round_of_16_not_yet_started?).to be false
      end
    end
  end

  describe '#finished?' do
    let!(:game1) { create(:game) }
    let!(:final) { create(:final) }

    context 'if final not finished' do
      it 'returns false' do
        expect(subject.finished?).to be false
      end
    end

    context 'if final not exists' do
      it 'returns false' do
        final.destroy
        expect(subject.finished?).to be false
      end
    end

    context 'if final is finished' do
      it 'returns true' do
        final.update_column(:finished, true)
        expect(subject.finished?).to be true
      end
    end
  end

  describe '#round_of_16_started?' do
    context 'if first game of "Round of 16" is in the future' do
      it 'returns false' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.from_now, round: ROUND_OF_16)

        expect(subject.round_of_16_started?).to be false
      end
    end

    context 'if first game of "Round of 16"" is not in the future' do
      it 'returns true' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.ago, round: ROUND_OF_16)

        expect(subject.round_of_16_started?).to be true
      end
    end
  end

  describe '#round_start_end_date_time' do
    let!(:game1) do
      create(:game, round: GROUP,
                    group: GROUP_A, start_at: 1.day.from_now)
    end
    let!(:game2) do
      create(:game, round: GROUP,
                    group: GROUP_A, start_at: 2.days.from_now)
    end
    let!(:game3) do
      create(:game, round: GROUP,
                    group: GROUP_B, start_at: 2.days.ago)
    end
    let!(:game4) do
      create(:game, round: GROUP,
                    group: GROUP_C, start_at: 1.day.ago)
    end

    it 'gets start and end date of group-round' do
      start_date_time, end_date_time = subject.round_start_end_date_time(GROUP)
      expect(start_date_time).to be_equal_to_time(game3.start_at)
      expect(end_date_time).to be_equal_to_time(game2.start_at)
    end

    it 'gets start and end date of round with no games' do
      start_date_time, end_date_time = subject.round_start_end_date_time(SEMIFINAL)
      expect(start_date_time).to be_nil
      expect(end_date_time).to be_nil
    end
  end

  describe '#round_of_32_started?' do
    context 'if first game of "Round of 16" is in the future' do
      it 'returns false' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.from_now, round: ROUND_OF_32)

        expect(subject.round_of_32_started?).to be false
      end
    end

    context 'if first game of "Round of 16" is not in the future' do
      it 'returns true' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.ago, round: ROUND_OF_32)

        expect(subject.round_of_32_started?).to be true
      end
    end

    context 'if no Round of 16 games exist' do
      it 'returns false without raising' do
        expect(subject.round_of_32_started?).to be false
      end
    end
  end

  describe '#round_of_32_not_yet_started?' do
    context 'if first game of "Round of 16" is in the future' do
      it 'returns true' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.from_now, round: ROUND_OF_32)

        expect(subject.round_of_32_not_yet_started?).to be true
      end
    end

    context 'if first game of "Round of 16" is not in the future' do
      it 'returns false' do
        Timecop.freeze(Time.zone.now)
        create(:game, start_at: 1.second.ago, round: ROUND_OF_32)

        expect(subject.round_of_32_not_yet_started?).to be false
      end
    end

    context 'if no Round of 16 games exist' do
      it 'returns true without raising' do
        expect(subject.round_of_32_not_yet_started?).to be true
      end
    end
  end
end
