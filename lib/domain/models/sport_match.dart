import 'package:live_odds/domain/models/sport.dart';

import 'betting_option.dart';

class SportMatch {
  SportMatch({
    required this.sport,
    required this.competitorA,
    required this.competitorB,
    required this.matchStartTime,
    required this.currentScore,
    required this.bettingOptions,
  });

  final Sport sport;
  final String competitorA;
  final String competitorB;
  final DateTime matchStartTime;
  final String currentScore;
  final List<BettingOption> bettingOptions;

  @override
  String toString() {
    return '''
      Sport: ${sport.icon} ${sport.value}
      Competitors: $competitorA vs $competitorB
      Start Time: $matchStartTime
      Score: $currentScore
      Betting Options: ${bettingOptions.join(', ')}
''';
  }
}
