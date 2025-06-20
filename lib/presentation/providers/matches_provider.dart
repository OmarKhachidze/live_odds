import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_odds/domain/repository/odds_repository.dart';

import '../../domain/models/sport_match.dart';

class OddsProvider extends ChangeNotifier {
  OddsProvider(this._source);

  final OddsRepository _source;

  StreamSubscription? _subscription;

  final List<SportMatch> _matches = [];
  List<SportMatch> get matches => _matches;


  void getMatchesAndStartOdds(int count) {
    _matches.clear();
    _matches.addAll(_source.getMatches(count));

    _subscription?.cancel();
    _subscription = _source.getOddsStream(_matches).listen((updatedMatches) {
      _matches
        ..clear()
        ..addAll(updatedMatches);
      notifyListeners();
    });
  }

  void getMatches(int count) {
    _matches.addAll(_source.getMatches(count));
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
