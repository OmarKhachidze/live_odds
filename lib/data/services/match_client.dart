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

  List<SportMatch> getMatches(
    int count,
    List<BettingOption> bettingOptions,
  ) {
    return List.generate(count, (_) => _generateRandomMatch(bettingOptions));
  }

  SportMatch _generateRandomMatch(List<BettingOption> bettingOptions) {
    final sport = sports[_random.nextInt(sports.length)];

    final competitorA = competitors[_random.nextInt(competitors.length)];
    String competitorB;
    do {
      competitorB = competitors[_random.nextInt(competitors.length)];
    } while (competitorA == competitorB); // Ensure different competitors

    final startTime = DateTime.now().add(
      Duration(minutes: _random.nextInt(10000)),
    );
    final currentScore = _generateRandomScore(sport);

    return SportMatch(
      sport: sport,
      competitorA: competitorA,
      competitorB: competitorB,
      matchStartTime: startTime,
      currentScore: currentScore,
      bettingOptions: bettingOptions.map((e) {
        if (e.odds != null) return e;
        e.odds = _randomOdds();
        return e;
      }).toList(),
    );
  }

  String _generateRandomScore(Sport sport) {
    final a = _random.nextInt(5);
    final b = _random.nextInt(5);
    return '$a-$b';
  }

  double _randomOdds() {
    return double.parse((1.2 + _random.nextDouble() * 3.0).toStringAsFixed(2));
  }
}
