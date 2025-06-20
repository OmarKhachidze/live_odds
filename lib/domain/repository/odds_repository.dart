import '../models/sport_match.dart';

abstract class OddsRepository {
  List<SportMatch> getMatches(int count);
  Stream<List<SportMatch>> getOddsStream(List<SportMatch> baseMatches);
}
