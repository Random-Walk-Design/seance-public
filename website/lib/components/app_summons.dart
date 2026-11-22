import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'app_strip.dart';
import 'summon_stage.dart';

/// The picture for "Trained on Real Apps": Séance summons the logo of each
/// app it knows ([AppStrip.apps]), one after another, forever.
///
/// Each turn, Séance's border springs in around a rounded square with its
/// sparkles, and a logo fades in inside it. The border fades, and after a
/// moment the row of logos slides left, making room for the next. The
/// earlier logos fade as they move away. After the last app comes the first
/// again.
///
/// The logos are the app strip's files in `web/logos/`: single-color SVGs,
/// used as masks, so they stay sharp at this larger size. It plays on a
/// [SummonStage], with the hero's border and sparkles. All CSS: every logo
/// runs the same animation, a turn apart.
class AppSummons extends StatelessComponent {
  const AppSummons({super.key});

  @override
  Component build(BuildContext context) {
    return SummonStage(
      children: [
        div(classes: 'app-summons', [
          for (final (index, (_, file)) in AppStrip.apps.indexed)
            div(
              classes: 'app-summon-logo',
              attributes: {
                // Each logo waits for its turn, so the stage starts empty
                // and the first logo is summoned first.
                'style':
                    '--logo:url(/logos/$file.svg);'
                    'animation-delay:${cssNumber(index * _turn)}s',
              },
              [i([])],
            ),
          div(classes: 'app-summon-spot', [
            div(classes: 'app-summon-glow', []),
            div(classes: 'app-summon-line', []),
            div(classes: 'app-summon-sparkles', [
              RawText(summonSparkles(width: 1, height: 1, count: 28, scale: 1.1, seed: 2026)),
            ]),
          ]),
        ]),
      ],
    );
  }

  // One turn, in seconds: the border springs in, the logo fades in, the
  // border fades (over the app's 0.4 s), a pause, then the slide.

  static const _turn = 3.2;
  static const _logoIn = 0.35;
  static const _logoShown = 1.1;
  static const _fade = 1.6;
  static const _faded = 2.0;
  static const _slide = 2.6;

  /// A moment in a turn as a keyframe percentage of one turn.
  static String _inTurn(double seconds) => '${cssNumber(seconds / _turn * 100)}%';

  /// A moment in the whole loop (every app's turn) as a keyframe percentage.
  static String _inLoop(double seconds) => '${cssNumber(seconds / (_turn * AppStrip.apps.length) * 100)}%';

  // Layout, in the stage's container units.

  /// Where logos are summoned: the middle of the stage.
  static const _spotX = 50;

  /// How far apart the logos in the row are.
  static const _slot = 36;

  /// A logo's size, and its border's.
  static const _logo = 34;
  static const _spot = 50;

  /// How opaque a logo is as it moves left, one turn after another.
  static const _trail = [1.0, 0.5, 0.0];

  static const _slideEasing = 'cubic-bezier(0.45, 0, 0.2, 1)';

  // The app's colors, as in the hero.
  static const _highlight = '#cd8cff';
  static const _glow = 'rgba(177, 51, 255, 0.7)';

  /// A logo's turns: summoned, then sliding left one slot per turn and
  /// fading, until it's gone; it waits there, invisible, for its next turn.
  static Map<String, Styles> get _logoKeyframes {
    Styles at(int slots, {double? opacity, double scale = 1, String? easing}) => Styles(
      raw: {
        'translate': '${-slots * _slot}cqw 0',
        'scale': cssNumber(scale),
        'opacity': cssNumber(opacity ?? _trail[slots]),
        'animation-timing-function': ?easing,
      },
    );
    return {
      '0%': at(0, opacity: 0, scale: 0.85),
      _inLoop(_logoIn): at(0, opacity: 0, scale: 0.85, easing: 'ease-out'),
      _inLoop(_logoShown): at(0),
      for (var slots = 0; slots < _trail.length - 1; slots++) ...{
        _inLoop(slots * _turn + _slide): at(slots, easing: _slideEasing),
        _inLoop((slots + 1) * _turn): at(slots + 1),
      },
      '100%': at(_trail.length - 1),
    };
  }

  @css
  static List<StyleRule> get styles => [
    css('.app-summons').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        // The row fades out toward the stage's left edge.
        'mask': 'linear-gradient(to right, transparent, #000 12cqw)',
        '-webkit-mask': 'linear-gradient(to right, transparent, #000 12cqw)',
      },
    ),

    // A logo: the glow around it, then the logo itself, as a mask over a
    // pale purple gradient.
    css('.app-summon-logo').styles(
      raw: {
        'position': 'absolute',
        'left': 'calc(${_spotX}cqw - ${cssNumber(_logo / 2)}cqh)',
        'top': '${cssNumber(50 - _logo / 2)}cqh',
        'width': '${_logo}cqh',
        'height': '${_logo}cqh',
        'opacity': '0',
        'filter': 'drop-shadow(0 0 2.5cqh rgba(177, 51, 255, 0.55))',
        'animation': 'app-summon-logo ${cssNumber(_turn * AppStrip.apps.length)}s linear infinite',
      },
    ),
    css('.app-summon-logo i').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        'background': 'linear-gradient(160deg, #fbf7ff, #c9a2ff)',
        'mask': 'var(--logo) center / contain no-repeat',
        '-webkit-mask': 'var(--logo) center / contain no-repeat',
      },
    ),
    css.keyframes('app-summon-logo', _logoKeyframes),

    // Séance's border, around the place logos are summoned.
    css('.app-summon-spot').styles(
      raw: {
        'position': 'absolute',
        'left': 'calc(${_spotX}cqw - ${cssNumber(_spot / 2)}cqh)',
        'top': '${cssNumber(50 - _spot / 2)}cqh',
        'width': '${_spot}cqh',
        'height': '${_spot}cqh',
        'pointer-events': 'none',
      },
    ),
    css('.app-summon-glow, .app-summon-line, .app-summon-sparkles').styles(
      raw: {'position': 'absolute', 'opacity': '0'},
    ),
    css('.app-summon-glow, .app-summon-line').styles(
      raw: {'animation': 'app-summon-border ${cssNumber(_turn)}s linear infinite'},
    ),
    css('.app-summon-glow').styles(
      raw: {
        'inset': '-3px',
        'border': '6px solid $_glow',
        'border-radius': '24%',
        'filter': 'blur(6px)',
      },
    ),
    css('.app-summon-line').styles(
      raw: {
        'inset': '-1px',
        'border': '2px solid $_highlight',
        'border-radius': '23%',
      },
    ),
    // A size container, for its sparkles' places (see [summonSparkles]).
    css('.app-summon-sparkles').styles(
      raw: {
        'container-type': 'size',
        'inset': '0',
        'animation': 'app-summon-sparkles ${cssNumber(_turn)}s linear infinite',
      },
    ),
    css.keyframes('app-summon-border', {
      // A spring, as in the app: a little past, then settling.
      '0%': Styles(raw: {'opacity': '0', 'scale': '1.12'}),
      _inTurn(0.3): Styles(raw: {'opacity': '1', 'scale': '0.98'}),
      _inTurn(0.5): Styles(raw: {'opacity': '1', 'scale': '1'}),
      _inTurn(_fade): Styles(raw: {'opacity': '1', 'scale': '1'}),
      _inTurn(_faded): Styles(raw: {'opacity': '0', 'scale': '1'}),
    }),
    css.keyframes('app-summon-sparkles', {
      '0%': Styles(raw: {'opacity': '0'}),
      _inTurn(0.25): Styles(raw: {'opacity': '1'}),
      _inTurn(_fade - 0.2): Styles(raw: {'opacity': '1'}),
      _inTurn(_faded - 0.1): Styles(raw: {'opacity': '0'}),
    }),

    // With Reduce Motion on: the first logo, in Séance's border (the hero
    // hides the sparkles).
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.app-summon-logo, .app-summon-glow, .app-summon-line, .app-summon-sparkles').styles(
        raw: {'animation': 'none'},
      ),
      css('.app-summon-logo:first-child, .app-summon-glow, .app-summon-line').styles(raw: {'opacity': '1'}),
    ]),
  ];
}
