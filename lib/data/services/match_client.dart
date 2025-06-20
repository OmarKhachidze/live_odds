import 'dart:math';

import '../../domain/models/betting_option.dart';
import '../../domain/models/sport.dart';
import '../../domain/models/sport_match.dart';
import '../dummy/competitor_countries.dart';

class MatchClient {
  factory MatchClient() => _instance;

  MatchClient._privateConstructor();

  static final MatchClient _instance = MatchClient._privateConstructor();

  static final _random = Random();

  static const List<Sport> sports = Sport.values;

  double generateRandomOdds() {
    return double.parse((1.2 + _random.nextDouble() * 3.0).toStringAsFixed(2));
  }

  List<SportMatch> getMatches(int count, List<BettingOption> templateOptions) {
    return List.generate(
      count,
      (index) =>
          _generateRandomMatch(index, _cloneWithNewOdds(templateOptions)),
    );
  }

  List<BettingOption> _cloneWithNewOdds(List<BettingOption> options) {
    return options.map((e) {
      return e.copyWith(odds: generateRandomOdds());
    }).toList();
  }

  SportMatch _generateRandomMatch(int id, List<BettingOption> bettingOptions) {
    final sport = sports[_random.nextInt(sports.length)];

    final competitorA = competitors[_random.nextInt(competitors.length)];
    String competitorB;
    do {
      competitorB = competitors[_random.nextInt(competitors.length)];
    } while (competitorA == competitorB);

    final startTime = DateTime.now().add(
      Duration(minutes: _random.nextInt(10000)),
    );
    final change = _generateRandomChange();

    return SportMatch(
      id: id,
      sport: sport,
      competitorA: competitorA,
      competitorB: competitorB,
      matchStartTime: startTime,
      currentScore: _generateRandomScore(sport),
      bettingOptions: bettingOptions,
      oddsChange: change,
    );
  }

  SportMatch updateOdds(SportMatch match) {
    final updatedOptions = match.bettingOptions.map((e) {
      return e.copyWith(odds: generateRandomOdds());
    }).toList();

    return match.copyWith(bettingOptions: updatedOptions);
  }

  OddsChange _generateRandomChange() {
    final ind = _random.nextInt(2);
    return OddsChange.values[ind];
  }

  String _generateRandomScore(Sport sport) {
    final a = _random.nextInt(5);
    final b = _random.nextInt(5);
    return '$a-$b';
  }
}
