import 'dart:math';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import '../mark.dart';
import '../releases.dart';

/// The top of the home page: a drawing of a Mac window, wearing the glowing
/// border and rising sparkles Séance puts around the windows it summons,
/// with Séance's name and download button inside.
///
/// The window runs off the bottom of the hero, which clips it. The hero is
/// dark in both light and dark mode.
///
/// The border and sparkles copy the app's (`seance/Panel/WindowHighlighter.swift`
/// and `SparkleView.swift` in the seance repo): the same colors, sizes,
/// timing, and motion, done in CSS because the site has no JavaScript.
class Hero extends StatelessComponent {
  const Hero({required this.release, super.key});

  /// The release to offer; null if nothing's released yet.
  final Release? release;

  @override
  Component build(BuildContext context) {
    return header(classes: 'hero', [
      div(classes: 'hero-backdrop', attributes: {'aria-hidden': 'true'}, [
        for (var blob = 1; blob <= 4; blob++) div(classes: 'blob blob-$blob', []),
      ]),
      div(classes: 'hero-stage', [
        div(classes: 'window', [
          div(classes: 'window-bar', attributes: {'aria-hidden': 'true'}, [i([]), i([]), i([])]),
          div(classes: 'window-body', [
            div(classes: 'mark', [RawText(markSvg(size: 72))]),
            h1([.text('Séance')]),
            p(classes: 'tagline', [.text('Save your Spaces. Summon them back.')]),
            if (release case final release?) ...[
              a(href: '${release.downloadUrl}', classes: 'button', [
                .text('Download Séance ${release.version}'),
              ]),
              p(classes: 'meta', [.text(release.summary)]),
              if (release.channel != Channel.stable)
                p(classes: 'note', [.text('Séance is in early development. Expect rough edges.')]),
            ] else
              p(classes: 'status', [.text('Coming soon for macOS')]),
          ]),
        ]),
        div(classes: 'aura', attributes: {'aria-hidden': 'true'}, [
          div(classes: 'aura-glow', []),
          div(classes: 'aura-line', []),
          RawText(_sparkles()),
        ]),
      ]),
    ]);
  }

  // Layout, in CSS pixels.

  /// The hero is never taller than this.
  static const _maxHeight = 700;

  /// From the top of the hero to the top of the window: room for sparkles
  /// to rise into, and it sets how much of the window shows.
  static const _windowTop = 148;

  /// How much of the window hangs below the hero's bottom edge.
  static const _windowOverhang = 64;
  static const _windowWidth = 1040;

  /// Close to macOS 26's window corner radius, as in the app.
  static const _cornerRadius = 16;

  // The sparkles, from the app's `SparkleField` at the scale it uses for
  // real windows (`HighlightOverlay.sparkleScale`).

  static const _scale = 2.5;

  /// Seconds from appearing to fading out.
  static const _lifetime = 1.4;

  /// How far a sparkle rises over its life, in the app. Here each sparkle
  /// rises between [_shortestRise] and [_tallestRise] times this, so they
  /// fade out at different heights instead of along one line.
  static const _rise = 36 * _scale;
  static const _shortestRise = 0.4;
  static const _tallestRise = 1.25;

  /// The app gives a sparkle a new random place each time it reappears. CSS
  /// can't, so each sparkle is this many elements that take turns, each
  /// with its own place: the pattern only repeats after this many lives.
  static const _lives = 3;

  /// Seconds for one twinkle (the app's `sin(elapsed * 14)`).
  static const _twinkle = 2 * pi / 14;

  /// The sparkles' elements. Each is placed on the window's top or side
  /// edges (the bottom edge is out of sight) and animated by the
  /// `sparkle-life` and `sparkle-twinkle` keyframes.
  static String _sparkles() {
    // The same sparkles on every build.
    final random = Random(1848);
    // The most of each side edge that can show.
    const sideHeight = _maxHeight - _windowTop;
    const perimeter = _windowWidth + sideHeight * 2;
    // The app's density: one sparkle at a time per (14 * scale) of border.
    final count = perimeter ~/ (14 * _scale);

    final html = StringBuffer();
    for (var index = 0; index < count; index++) {
      for (var life = 0; life < _lives; life++) {
        final distance = random.nextDouble() * perimeter;
        final String left, top;
        if (distance < _windowWidth) {
          left = '${_number(distance / _windowWidth * 100)}%';
          top = '0';
        } else if (distance < _windowWidth + sideHeight) {
          left = '100%';
          top = '${_number(distance - _windowWidth)}px';
        } else {
          left = '0';
          top = '${_number(distance - _windowWidth - sideHeight)}px';
        }
        final radius = (2.5 + random.nextDouble() * 3) * _scale;
        final sway = (random.nextDouble() - 0.5) * 12 * _scale;
        final rise = _rise * (_shortestRise + random.nextDouble() * (_tallestRise - _shortestRise));
        final white = random.nextDouble() < 0.5;
        // Negative delays, so the page loads with sparkles already rising.
        final start = -(index / count + life) * _lifetime;
        final twinkleStart = -random.nextDouble() * _twinkle;
        html.write(
          '<span class="sparkle${white ? ' white' : ''}" style="left:$left;top:$top;'
          '--r:${_number(radius)}px;--sway:${_number(sway)}px;--rise:${_number(rise)}px;'
          '--start:${_number(start)}s;--twinkle:${_number(twinkleStart)}s"><i></i></span>',
        );
      }
    }
    return html.toString();
  }

  /// One sparkle's life as keyframes: the app's formulas, sampled. The life
  /// takes the first 1/[_lives] of the animation; the sparkle is invisible
  /// for the rest, while the others that share its turn have theirs.
  static Map<String, Styles> get _lifeKeyframes {
    const samples = 10;
    return {
      for (var sample = 0; sample <= samples; sample++)
        '${_number(sample / samples * 100 / _lives)}%': () {
          final progress = sample / samples;
          // Ease out: quick lift-off, then drifting.
          final lift = 1 - pow(1 - progress, 2);
          final arc = sin(progress * pi);
          return Styles(
            raw: {
              'translate': 'calc(var(--sway) * ${_number(arc)}) calc(var(--rise) * ${_number(-lift)})',
              'scale': _number(1 - progress * 0.4),
              'opacity': _number(arc),
            },
          );
        }(),
      '100%': Styles(raw: {'translate': '0 calc(var(--rise) * -1)', 'scale': '0.6', 'opacity': '0'}),
    };
  }

  static String _number(num value) => value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');

  // The app's colors (`SeancePalette`): the border's crisp line and the
  // colored sparkles, and the border's soft glow.
  static const _highlight = '#cd8cff';
  static const _glow = 'rgba(177, 51, 255, 0.7)';

  /// The halo behind each sparkle: the glow color at 35%.
  static const _halo = 'rgba(177, 51, 255, 0.245)';

  @css
  static List<StyleRule> get styles => [
    css('.hero').styles(
      raw: {
        ...darkColors,
        'position': 'relative',
        'height': 'min(100svh, ${_maxHeight}px)',
        'min-height': '640px',
        'overflow': 'hidden',
        'background': '#0c0618',
        'color': 'var(--text)',
      },
    ),

    // Very faint blurred splotches of purple and pink, drifting slowly.
    css('.hero-backdrop, .blob').styles(raw: {'position': 'absolute'}),
    css('.hero-backdrop').styles(raw: {'inset': '0'}),
    css('.blob').styles(
      raw: {
        'border-radius': '50%',
        'background': 'radial-gradient(closest-side, var(--blob), transparent)',
        'animation': 'blob-drift 24s ease-in-out infinite alternate',
      },
    ),
    css('.blob-1').styles(
      raw: {
        '--blob': 'rgba(140, 62, 255, 0.17)',
        'width': '760px',
        'height': '620px',
        'left': 'calc(50% - 820px)',
        'top': '-180px',
      },
    ),
    css('.blob-2').styles(
      raw: {
        '--blob': 'rgba(255, 70, 170, 0.12)',
        'width': '640px',
        'height': '560px',
        'left': 'calc(50% + 160px)',
        'top': '-220px',
        'animation-duration': '31s',
        'animation-delay': '-9s',
      },
    ),
    css('.blob-3').styles(
      raw: {
        '--blob': 'rgba(214, 72, 255, 0.1)',
        'width': '700px',
        'height': '600px',
        'left': 'calc(50% - 300px)',
        'top': '300px',
        'animation-duration': '27s',
        'animation-delay': '-15s',
      },
    ),
    css('.blob-4').styles(
      raw: {
        '--blob': 'rgba(92, 70, 255, 0.13)',
        'width': '620px',
        'height': '620px',
        'left': 'calc(50% + 320px)',
        'top': '240px',
        'animation-duration': '35s',
        'animation-delay': '-4s',
      },
    ),
    css.keyframes('blob-drift', {
      'from': Styles(raw: {'translate': '-40px -24px', 'scale': '1'}),
      'to': Styles(raw: {'translate': '48px 30px', 'scale': '1.14'}),
    }),

    // The window, centered, running off the hero's bottom edge.
    css('.hero-stage').styles(
      raw: {
        'position': 'absolute',
        'top': '${_windowTop}px',
        'bottom': '-${_windowOverhang}px',
        'left': '50%',
        'width': 'min(${_windowWidth}px, 100% - 48px)',
        'translate': '-50%',
      },
    ),
    css('.window').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        'display': 'flex',
        'flex-direction': 'column',
        'overflow': 'hidden',
        'border-radius': '${_cornerRadius}px',
        'background': 'linear-gradient(rgba(40, 29, 62, 0.74), rgba(20, 13, 34, 0.86))',
        'backdrop-filter': 'blur(28px) saturate(1.3)',
        '-webkit-backdrop-filter': 'blur(28px) saturate(1.3)',
        'box-shadow': '0 30px 90px rgba(4, 0, 12, 0.6)',
      },
    ),
    css('.window-bar').styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'gap': '8px',
        'flex': 'none',
        'height': '44px',
        'padding': '0 16px',
        'background': 'rgba(255, 255, 255, 0.045)',
        'border-bottom': '1px solid rgba(255, 255, 255, 0.07)',
      },
    ),
    // Close, minimize, zoom.
    css('.window-bar i').styles(
      raw: {'width': '12px', 'height': '12px', 'border-radius': '50%', 'background': '#ff5f57'},
    ),
    css('.window-bar i:nth-child(2)').styles(raw: {'background': '#febc2e'}),
    css('.window-bar i:nth-child(3)').styles(raw: {'background': '#28c840'}),
    css('.window-body').styles(
      raw: {
        'flex': '1',
        'display': 'flex',
        'flex-direction': 'column',
        'align-items': 'center',
        'justify-content': 'center',
        // Centers the contents in the part of the window that shows.
        'padding': '0 24px ${_windowOverhang}px',
        'text-align': 'center',
      },
    ),

    css('.mark').styles(
      raw: {
        'line-height': '0',
        'color': 'var(--accent)',
        'filter': 'drop-shadow(0 0 18px var(--glow))',
      },
    ),
    css('.hero h1').styles(
      raw: {
        'margin': '20px 0 8px',
        'font': '700 clamp(2.4rem, 7vw, 3.4rem)/1.1 -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
        'letter-spacing': '-0.02em',
      },
    ),
    css('.tagline').styles(raw: {'margin': '0 0 28px', 'font-size': '1.2rem', 'color': 'var(--muted)'}),
    css('.button').styles(
      raw: {
        'display': 'inline-block',
        'padding': '14px 28px',
        'border-radius': '12px',
        'background': 'var(--accent)',
        'color': 'var(--on-accent)',
        'font-weight': '600',
        'font-size': '1.1rem',
        'text-decoration': 'none',
        'box-shadow': '0 6px 24px var(--glow)',
      },
    ),
    css('.button:hover').styles(raw: {'filter': 'brightness(1.08)'}),
    css('.button:focus-visible').styles(
      raw: {
        'outline': '3px solid var(--accent)',
        'outline-offset': '3px',
      },
    ),
    css('.hero .meta').styles(raw: {'margin': '12px 0 0', 'color': 'var(--muted)', 'font-size': '0.9rem'}),
    css('.note').styles(
      raw: {
        'margin': '64px 0 0',
        'padding': '10px 16px',
        'border-radius': '10px',
        'background': 'var(--surface)',
        'font-size': '0.9rem',
      },
    ),
    css('.status').styles(
      raw: {
        'margin': '0',
        'padding': '6px 14px',
        'border': '1px solid var(--accent)',
        'border-radius': '999px',
        'color': 'var(--accent)',
        'font-size': '0.9rem',
      },
    ),

    // Séance's border, over the window: a wide, soft glow, then a crisp
    // line on top, both centered on the window's edge.
    css('.aura').styles(raw: {'position': 'absolute', 'inset': '0', 'pointer-events': 'none'}),
    css('.aura-glow, .aura-line').styles(
      raw: {
        'position': 'absolute',
        // As in the app, the border arrives a little too big and faded
        // out, and springs down onto the window.
        'animation': 'aura-arrive 0.6s cubic-bezier(0.3, 1.45, 0.6, 1) backwards',
      },
    ),
    css('.aura-glow').styles(
      raw: {
        'inset': '-4px',
        'border': '8px solid $_glow',
        'border-radius': '${_cornerRadius + 4}px',
        'filter': 'blur(8px)',
      },
    ),
    css('.aura-line').styles(
      raw: {
        'inset': '-1.5px',
        'border': '3px solid $_highlight',
        'border-radius': '${_cornerRadius + 1.5}px',
      },
    ),
    css.keyframes('aura-arrive', {
      'from': Styles(raw: {'scale': '1.05 1.07', 'opacity': '0'}),
    }),

    // A sparkle: a point on the border that the life animation moves; the
    // star and its halo are drawn around it by the <i>, which twinkles.
    css('.sparkle').styles(
      raw: {
        'position': 'absolute',
        'color': _highlight,
        'opacity': '0',
        'animation': 'sparkle-life ${_number(_lifetime * _lives)}s linear var(--start) infinite',
      },
    ),
    css('.sparkle.white').styles(raw: {'color': '#fff'}),
    css('.sparkle i').styles(
      raw: {
        'position': 'absolute',
        // The halo is 1.6 times the star's radius.
        'left': 'calc(var(--r) * -1.6)',
        'top': 'calc(var(--r) * -1.6)',
        'width': 'calc(var(--r) * 3.2)',
        'height': 'calc(var(--r) * 3.2)',
        'border-radius': '50%',
        'background': _halo,
        'animation': 'sparkle-twinkle ${_number(_twinkle)}s ease-in-out var(--twinkle) infinite',
      },
    ),
    // A four-pointed star.
    css('.sparkle i::before').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'inset': '18.75%',
        'background': 'currentColor',
        'clip-path':
            'polygon(50% 0, 59.9% 40.1%, 100% 50%, 59.9% 59.9%, 50% 100%, 40.1% 59.9%, 0 50%, 40.1% 40.1%)',
      },
    ),
    css.keyframes('sparkle-life', _lifeKeyframes),
    css.keyframes('sparkle-twinkle', {
      '50%': Styles(raw: {'scale': '0.3'}),
    }),

    // Like the app with Reduce Motion on: the border, without sparkles.
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.sparkle').styles(raw: {'display': 'none'}),
      css('.blob, .aura-glow, .aura-line').styles(raw: {'animation': 'none'}),
    ]),
  ];
}
