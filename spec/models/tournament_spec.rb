require 'rails_helper'

describe Tournament, :type => :model do

  subject { Tournament }

  describe '#started?' do

    context 'if first game is in the future' do
      it 'returns false' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now + 1.second)

        expect(subject.started?).to be false
      end
    end

    context 'if first game is not in the future' do
      it 'returns true' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now - 1.second)

        expect(subject.started?).to be true
      end
    end

  end

  describe '#not_yet_started?' do

    context 'if first game is in the future' do
      it 'returns true' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now + 1.second)

        expect(subject.not_yet_started?).to be true
      end
    end

    context 'if first game is not in the future' do
      it 'returns false' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now - 1.second)

        expect(subject.not_yet_started?).to be false
      end
    end

  end

  describe '#finished?' do
    let!(:game1) {create :game}
    let!(:final) {create :final}

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

  describe '#round_start_end_date_time' do

    let!(:game1) { create(:game, round: GROUP,
                          group: GROUP_A, start_at: Time.now + 1.day)}
    let!(:game2) { create(:game, round: GROUP,
                          group: GROUP_A, start_at: Time.now + 2.day)}
    let!(:game3) { create(:game, round: GROUP,
                           group: GROUP_B, start_at: Time.now - 2.day)}
    let!(:game4) { create(:game, round: GROUP,
                           group: GROUP_C, start_at: Time.now - 1.day)}


    it 'gets start and end date of group-round' do
      start_date_time, end_date_time = subject.round_start_end_date_time(GROUP)
      expect(start_date_time).to be_equal_to_time(game3.start_at)
      expect(end_date_time).to be_equal_to_time(game2.start_at)
    end

    it 'gets start and end date of round with no games' do
      start_date_time, end_date_time = subject.round_start_end_date_time(SEMIFINAL)
      expect(start_date_time).to be nil
      expect(end_date_time).to be nil
    end


  end

end