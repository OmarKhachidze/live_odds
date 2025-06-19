import 'betting_type.dart';

class BettingOption {
  BettingOption({
    required this.type,
    required this.description,
    required this.odds,
  });

  final BettingType type;
  final String description;
  double? odds;
}
