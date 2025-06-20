import 'betting_type.dart';

class BettingOption {
  BettingOption({
    required this.type,
    required this.description,
    this.odds,
  });

  final BettingType type;
  final String description;
  final double? odds;

  BettingOption copyWith({
    BettingType? type,
    String? description,
    double? odds,
  }) {
    return BettingOption(
      type: type ?? this.type,
      description: description ?? this.description,
      odds: odds ?? this.odds,
    );
  }

  @override
  String toString() => '$description: ${odds?.toStringAsFixed(2) ?? 'N/A'}';
}