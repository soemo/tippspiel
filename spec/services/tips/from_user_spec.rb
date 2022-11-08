require 'rails_helper'

describe Tips::FromUser do

  subject { Tips::FromUser }

  let(:user_id) {1}

  let(:game1) {Game.new(id: 111, start_at: DateTime.tomorrow)}
  let(:game2) {Game.new(id: 222, start_at: DateTime.tomorrow)}
  let(:game3_started) {Game.new(id: 333, start_at: DateTime.now - 1.second)}

  context 'if user_id present? and no tips exists' do

    context 'and no random tips created' do

      it 'return new created tips without goals' do
        expect(Tip.count).to eq(0)
        expect(TipQueries).to receive(:exists_for_user_id).with(user_id).and_return(false)
        tips = [Tip.new, Tip.new]
        expect(TipQueries).to receive(:all_by_user_id_ordered_games_start_at).with(user_id).once.and_return(tips)
        expect(GameQueries).to receive(:all_game_ids).once.and_return([game1.id, game2.id])
        expect(UserQueries).to receive(:needs_random_tips_for_user_id?).once.
          with(user_id).and_return(false)

        subject.call(user_id: 1)

        new_tipps = Tip.all
        expect(new_tipps.size).to eq(2)
        expect(new_tipps.first.game_id).to eq(game1.id)
        expect(new_tipps.first.user_id).to eq(user_id)
        expect(new_tipps.first.team1_goals).to eq(nil)
        expect(new_tipps.first.team2_goals).to eq(nil)
        expect(new_tipps.last.game_id).to eq(game2.id)
        expect(new_tipps.last.user_id).to eq(user_id)
        expect(new_tipps.last.team1_goals).to eq(nil)
        expect(new_tipps.last.team2_goals).to eq(nil)
      end
    end

    context 'and random tips created' do

      it 'return new created tips with goals' do
        expect(Tip.count).to eq(0)
        expect(TipQueries).to receive(:exists_for_user_id).with(user_id).and_return(false)
        tips = [Tip.new, Tip.new]
        expect(TipQueries).to receive(:all_by_user_id_ordered_games_start_at).with(user_id).once.and_return(tips)
        expect(GameQueries).to receive(:all_game_ids).once.and_return([game1.id, game2.id])
        expect(GameQueries).to receive(:started_game_ids).once.and_return([])
        expect(UserQueries).to receive(:needs_random_tips_for_user_id?).once.
          with(user_id).and_return(true)

        subject.call(user_id: 1)

        new_tipps = Tip.all
        expect(new_tipps.size).to eq(2)
        expect(new_tipps.first.game_id).to eq(game1.id)
        expect(new_tipps.first.user_id).to eq(user_id)
        expect(new_tipps.first.team1_goals).to be_between(0, 5)
        expect(new_tipps.first.team2_goals).to be_between(0, 5)

        expect(new_tipps.second.game_id).to eq(game2.id)
        expect(new_tipps.second.user_id).to eq(user_id)
        expect(new_tipps.second.team1_goals).to be_between(0, 5)
        expect(new_tipps.second.team2_goals).to be_between(0, 5)
      end
    end

    context 'and random tips created only for games in the future' do

      it 'return new created tips with goals' do
        expect(Tip.count).to eq(0)
        expect(TipQueries).to receive(:exists_for_user_id).with(user_id).and_return(false)
        tips = [Tip.new, Tip.new]
        expect(TipQueries).to receive(:all_by_user_id_ordered_games_start_at).with(user_id).once.and_return(tips)
        expect(GameQueries).to receive(:all_game_ids).once.and_return([game1.id, game2.id, game3_started.id])
        expect(GameQueries).to receive(:started_game_ids).once.and_return([game3_started.id])
        expect(UserQueries).to receive(:needs_random_tips_for_user_id?).once.
          with(user_id).and_return(true)

        subject.call(user_id: 1)

        new_tipps = Tip.all
        expect(new_tipps.size).to eq(3)
        expect(new_tipps.first.game_id).to eq(game1.id)
        expect(new_tipps.first.user_id).to eq(user_id)
        expect(new_tipps.first.team1_goals).to be_between(0, 5)
        expect(new_tipps.first.team2_goals).to be_between(0, 5)

        expect(new_tipps.second.game_id).to eq(game2.id)
        expect(new_tipps.second.user_id).to eq(user_id)
        expect(new_tipps.second.team1_goals).to be_between(0, 5)
        expect(new_tipps.second.team2_goals).to be_between(0, 5)

        expect(new_tipps.last.game_id).to eq(game3_started.id)
        expect(new_tipps.last.user_id).to eq(user_id)
        expect(new_tipps.last.team1_goals).to be_nil
        expect(new_tipps.last.team2_goals).to be_nil
      end
    end
  end

  context 'if user id present? and tips exists'do

    it 'return existing tips' do
      tips = [Tip.new, Tip.new]
      expect(TipQueries).to receive(:exists_for_user_id).with(user_id).and_return(true)
      expect(TipQueries).to receive(:all_by_user_id_ordered_games_start_at).
                                with(user_id).once.and_return(tips)
      expect(GameQueries).to_not receive(:all_game_ids)

      expect(subject.call(user_id: user_id) ).to eq(tips)
    end
  end

  context 'if user id not present? 'do

    it 'returns empty array' do
      expect(TipQueries).to_not receive(:all_by_user_id_ordered_games_start_at).with(user_id)

      expect(subject.call(user_id: nil)).to eq([])
    end
  end
end