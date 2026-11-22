import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'hero.dart';

/// The dark purple stage the feature pictures play on: the hero's background
/// (`#0c0618` with faint drifting light, reusing its `blob-drift` keyframes),
/// inset in a feature's cutout so the cutout's dashed outline and light
/// background still show around it.
///
/// It's a size container, so what's inside can be sized in `cqw` and `cqh`
/// and scale with the cutout.
class SummonStage extends StatelessComponent {
  const SummonStage({required this.children, super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'summon-stage',
      attributes: {'aria-hidden': 'true'},
      [
        for (var blob = 1; blob <= 3; blob++) div(classes: 'summon-blob summon-blob-$blob', []),
        ...children,
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.summon-stage').styles(
      raw: {
        'position': 'absolute',
        'inset': '14px',
        'overflow': 'hidden',
        'border-radius': '10px',
        'background': '#0c0618',
        'container-type': 'size',
      },
    ),
    css('.summon-blob').styles(
      raw: {
        'position': 'absolute',
        'border-radius': '50%',
        'background': 'radial-gradient(closest-side, var(--blob), transparent)',
        'animation': 'blob-drift 22s ease-in-out infinite alternate',
      },
    ),
    css('.summon-blob-1').styles(
      raw: {
        '--blob': 'rgba(140, 62, 255, 0.3)',
        'width': '80cqw',
        'height': '90cqh',
        'left': '-24cqw',
        'top': '-30cqh',
      },
    ),
    css('.summon-blob-2').styles(
      raw: {
        '--blob': 'rgba(255, 70, 170, 0.18)',
        'width': '70cqw',
        'height': '85cqh',
        'left': '50cqw',
        'top': '-36cqh',
        'animation-duration': '29s',
        'animation-delay': '-9s',
      },
    ),
    css('.summon-blob-3').styles(
      raw: {
        '--blob': 'rgba(92, 70, 255, 0.24)',
        'width': '80cqw',
        'height': '90cqh',
        'left': '30cqw',
        'top': '44cqh',
        'animation-duration': '33s',
        'animation-delay': '-4s',
      },
    ),
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.summon-blob').styles(raw: {'animation': 'none'}),
    ]),
  ];
}

/// The hero's sparkles (its `sparkle` classes and keyframes, which copy the
/// app's), scattered over the edges of a box [width] wide for each [height]
/// high, placed in container units so they follow the box's real size: the
/// box must be a size container. [scale] is relative to the app's hovered
/// tiles, as in the hero (which uses 2.5).
String summonSparkles({
  required double width,
  required double height,
  required int count,
  required double scale,
  int seed = 1848,
}) {
  // The hero's numbers: each sparkle rises up to this far.
  final rise = 36 * scale;

  final random = Random(seed);
  final perimeter = (width + height) * 2;
  final html = StringBuffer();
  for (var index = 0; index < count; index++) {
    final lives = [
      for (var life = 0; life < sparkleLives; life++)
        () {
          final distance = random.nextDouble() * perimeter;
          final double left, top;
          if (distance < width) {
            (left, top) = (distance / width, 0);
          } else if (distance < width + height) {
            (left, top) = (1, (distance - width) / height);
          } else if (distance < width * 2 + height) {
            (left, top) = ((distance - width - height) / width, 1);
          } else {
            (left, top) = (0, (distance - width * 2 - height) / height);
          }
          return (
            x: '${cssNumber(left * 100)}cqw',
            y: '${cssNumber(top * 100)}cqh',
            radius: (2.5 + random.nextDouble() * 3) * scale,
            sway: (random.nextDouble() - 0.5) * 12 * scale,
            rise: rise * (0.4 + random.nextDouble() * 0.85),
            white: random.nextDouble() < 0.5,
            twinkleStart: -random.nextDouble() * (2 * pi / 14),
          );
        }(),
    ];
    html.write(sparkleElement(lives, index: index, count: count, largestRadius: 5.5 * scale));
  }
  return html.toString();
}

/// A number for CSS, with at most two decimals and no trailing zeros.
String cssNumber(num value) => value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
