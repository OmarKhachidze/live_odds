import 'package:flutter/material.dart';
import 'package:live_odds/domain/repository/odds_repository.dart';

import '../../domain/models/sport_match.dart';

class OddsProvider extends ChangeNotifier {
  OddsProvider(this.source);

  final OddsRepository source;

  final List<SportMatch> _matches = [];
  List<SportMatch> get matches => _matches;

  void getMatches(int count) {
    _matches.addAll(source.getMatches(count));
    notifyListeners();
  }
}
