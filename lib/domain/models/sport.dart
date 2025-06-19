enum Sport {
  soccer('Soccer', '⚽'),
  basketball('Basketball', '🏀'),
  rugby('Rugby', '🏉'),
  tennis('Tennis', '🎾'),
  hockey('Hockey', '🏒');

  const Sport(this.value, this.icon);

  final String value;
  final String icon;
}
