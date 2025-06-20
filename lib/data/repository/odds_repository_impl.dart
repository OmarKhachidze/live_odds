import 'package:live_odds/data/services/match_client.dart';

import '../../domain/models/betting_option.dart';
import '../../domain/models/betting_type.dart';
import '../../domain/models/sport_match.dart';
import '../../domain/repository/odds_repository.dart';

class ImplOddsRepository implements OddsRepository {
  @override
  List<SportMatch> getMatches(int count) {
    return MatchClient().getMatches(count, [
      BettingOption(type: BettingType.oneXTwo, description: '1', odds: null),
      BettingOption(type: BettingType.oneXTwo, description: 'X', odds: null),
      BettingOption(type: BettingType.oneXTwo, description: '2', odds: null),
      BettingOption(
        type: BettingType.doubleChance,
        description: '1X',
        odds: null,
      ),
      BettingOption(type: BettingType.total, description: 'U2.5', odds: null),
    ]);
  }

  @override
  Stream<List<SportMatch>> getOddsStream(List<SportMatch> baseMatches) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));

      final updatedMatches = baseMatches.map((match) {
        return MatchClient().updateOdds(match);
      }).toList();

      yield updatedMatches;
    }
  }
}
