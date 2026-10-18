/// Séance's mark: a large four-pointed star with two smaller companions.
///
/// The same stars as Séance's menu bar icon (`seance/Panel/SeanceMark.swift`
/// in the seance repo) and the favicon (`web/favicon.svg`). Change all three
/// together.
library;

/// On a 24-unit grid, y pointing down: each star's center x, center y, and
/// radius (center to tip).
const _stars = [(9.5, 14.5, 9.0), (18.8, 5.2, 4.6), (20.6, 19.6, 2.8)];

/// How far each curved side bows toward the star's center.
const _pinch = 0.15;

/// SVG path data for the mark, in a `0 0 24 24` view box.
String markPath() {
  String number(double value) => value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  const tips = [(0.0, -1.0), (1.0, 0.0), (0.0, 1.0), (-1.0, 0.0)];
  final path = StringBuffer();
  for (final (x, y, radius) in _stars) {
    String point(double dx, double dy) => '${number(x + dx * radius)} ${number(y + dy * radius)}';
    path.write('M${point(tips[0].$1, tips[0].$2)}');
    for (var i = 0; i < 4; i++) {
      final from = tips[i], to = tips[(i + 1) % 4];
      path.write(' Q${point((from.$1 + to.$1) * _pinch, (from.$2 + to.$2) * _pinch)} ${point(to.$1, to.$2)}');
    }
    path.write('Z');
  }
  return path.toString();
}

/// The mark as an inline SVG, filled with the current text color.
String markSvg({required int size}) =>
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="$size" height="$size" '
    'aria-hidden="true" focusable="false"><path fill="currentColor" d="${markPath()}"/></svg>';
