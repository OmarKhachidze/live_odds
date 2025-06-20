import 'package:live_odds/domain/models/sport.dart';

import 'betting_option.dart';

enum OddsChange { increase, decrease, none }

class SportMatch {
  SportMatch({
    required this.id,
    required this.sport,
    required this.competitorA,
    required this.competitorB,
    required this.matchStartTime,
    required this.currentScore,
    required this.bettingOptions,
    required this.oddsChange,
  });

  final int id;
  final Sport sport;
  final String competitorA;
  final String competitorB;
  final DateTime matchStartTime;
  final String currentScore;
  final List<BettingOption> bettingOptions;
  final OddsChange oddsChange;

  SportMatch copyWith({
    int? id,
    Sport? sport,
    String? competitorA,
    String? competitorB,
    DateTime? matchStartTime,
    String? currentScore,
    List<BettingOption>? bettingOptions,
    OddsChange? oddsChange,
  }) {
    return SportMatch(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      competitorA: competitorA ?? this.competitorA,
      competitorB: competitorB ?? this.competitorB,
      matchStartTime: matchStartTime ?? this.matchStartTime,
      currentScore: currentScore ?? this.currentScore,
      bettingOptions: bettingOptions ?? this.bettingOptions,
      oddsChange: oddsChange ?? this.oddsChange,
    );
  }

  @override
  String toString() {
    return '''
      ID: $id
      Sport: ${sport.icon} ${sport.value}
      Competitors: $competitorA vs $competitorB
      Start Time: $matchStartTime
      Score: $currentScore
      Betting Options: ${bettingOptions.join(', ')}
      Odds Change: $oddsChange
''';
  }
}