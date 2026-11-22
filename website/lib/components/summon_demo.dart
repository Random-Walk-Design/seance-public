import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'summon_stage.dart';

/// The picture for "Save Windows & Summon Back": a small Chrome-like window,
/// open to a made-up web page, that Séance closes and, after a moment,
/// summons back. Both times it wears Séance's glowing border and sparkles,
/// as in the app, which highlights windows while it closes them and while it
/// reopens them (`Summoning` in `WindowHighlighter.swift`). It loops.
///
/// It plays on a [SummonStage]. The border is the hero's, and the sparkles
/// its `sparkle` classes and keyframes ([summonSparkles]), at a smaller
/// scale. All CSS, because the site has no JavaScript.
class SummonDemo extends StatelessComponent {
  const SummonDemo({super.key});

  @override
  Component build(BuildContext context) {
    return SummonStage(
      children: [
        div(classes: 'summon-frame', [
          div(classes: 'summon-aura', [
            div(classes: 'summon-aura-glow', []),
            div(classes: 'summon-aura-line', []),
          ]),
          div(classes: 'chrome', [
            div(classes: 'chrome-tabs', [
              div(classes: 'chrome-lights', [i([]), i([]), i([])]),
              div(classes: 'chrome-tab active', [
                span(classes: 'chrome-favicon', []),
                span(classes: 'chrome-tab-title', [.text('The Lantern Times')]),
                span(classes: 'chrome-tab-close', [.text('×')]),
              ]),
              div(classes: 'chrome-tab', [
                span(classes: 'chrome-favicon moon', []),
                span(classes: 'chrome-tab-title', [.text('Moon Phases')]),
              ]),
              span(classes: 'chrome-new-tab', [.text('+')]),
            ]),
            div(classes: 'chrome-toolbar', [
              RawText(_toolbarIcons),
              div(classes: 'chrome-omnibox', [
                RawText(_lockIcon),
                span([.text('lanterntimes.example/lighthouses')]),
              ]),
              span(classes: 'chrome-profile', []),
            ]),
            div(classes: 'chrome-page', [
              div(classes: 'page-masthead', [
                span(classes: 'page-logo', [.text('The Lantern Times')]),
                span(classes: 'page-nav', [i([]), i([]), i([])]),
              ]),
              div(classes: 'page-article', [
                div(classes: 'page-photo', [
                  span(classes: 'page-moon', []),
                  span(classes: 'page-tower', []),
                ]),
                div(classes: 'page-text', [
                  span(classes: 'page-kicker', [.text('Travel')]),
                  span(classes: 'page-headline', [.text('Ten Haunted Lighthouses Worth the Drive')]),
                  i([]),
                  i([]),
                  i([]),
                  i(classes: 'short', []),
                ]),
              ]),
            ]),
          ]),
          div(classes: 'summon-sparkles', [RawText(summonSparkles(width: 1.56, height: 1, count: 34, scale: 1.1))]),
        ]),
      ],
    );
  }

  /// Back, forward, and reload.
  static const _toolbarIcons =
      '<svg class="chrome-nav" viewBox="0 0 60 16" fill="none" stroke="currentColor" '
      'stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M13 8H3M7.5 3.5 3 8l4.5 4.5"/>'
      '<path d="M23 8h10M28.5 3.5 33 8l-4.5 4.5" opacity="0.4"/>'
      '<path d="M56 8a5 5 0 1 1-1.5-3.6M55 2.5v2.5h-2.5"/>'
      '</svg>';

  static const _lockIcon =
      '<svg class="chrome-lock" viewBox="0 0 12 14" fill="none" stroke="currentColor" stroke-width="1.4">'
      '<rect x="1.5" y="6" width="9" height="7" rx="1.5"/><path d="M3.5 6V4.5a2.5 2.5 0 0 1 5 0V6"/>'
      '</svg>';

  // The loop, in seconds: the window shows; Séance's border arrives around
  // it, and it closes, and the border fades once it's gone; the stage stays
  // empty for a moment; then the border arrives again, the window reappears
  // inside it, and the border fades.

  static const _loop = 9.4;
  static const _save = 1.4;
  static const _close = 2.8;
  static const _closed = 3.0;
  static const _summon = 4.8;
  static const _appear = 5.35;
  static const _shown = 5.65;
  static const _fade = 7.3;

  /// The app's `fadeOut` duration.
  static const _fadeDuration = 0.4;

  /// The border's keyframes for one appearance: it springs in at [arrive],
  /// as in the app (a little past, then settling), and fades from [fade].
  static Map<String, Styles> _auraVisit(double arrive, double fade) => {
    _at(arrive): Styles(raw: {'opacity': '0', 'scale': '1.06 1.09'}),
    _at(arrive + 0.3): Styles(raw: {'opacity': '1', 'scale': '0.99'}),
    _at(arrive + 0.5): Styles(raw: {'opacity': '1', 'scale': '1'}),
    _at(fade): Styles(raw: {'opacity': '1', 'scale': '1'}),
    _at(fade + _fadeDuration): Styles(raw: {'opacity': '0', 'scale': '1'}),
  };

  /// The sparkles' keyframes for one appearance of the border.
  static Map<String, Styles> _sparklesVisit(double arrive, double fade) => {
    _at(arrive): Styles(raw: {'opacity': '0'}),
    _at(arrive + 0.25): Styles(raw: {'opacity': '1'}),
    _at(fade - 0.2): Styles(raw: {'opacity': '1'}),
    _at(fade + _fadeDuration - 0.1): Styles(raw: {'opacity': '0'}),
  };

  static String _at(double seconds) => '${cssNumber(seconds / _loop * 100)}%';

  // The app's colors, as in the hero.
  static const _highlight = '#cd8cff';
  static const _glow = 'rgba(177, 51, 255, 0.7)';

  static const _font = '-apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif';

  @css
  static List<StyleRule> get styles => [
    // The window's place, centered on the stage.
    css('.summon-frame').styles(
      raw: {
        'position': 'absolute',
        'left': '13cqw',
        'right': '13cqw',
        'top': '13cqh',
        'bottom': '13cqh',
        'font': '1.9cqw/1.3 $_font',
      },
    ),

    // Séance's border: a soft glow and a crisp line on the window's edge.
    css('.summon-aura, .summon-sparkles').styles(
      raw: {'position': 'absolute', 'inset': '0', 'pointer-events': 'none', 'opacity': '0'},
    ),
    css('.summon-aura').styles(
      raw: {'z-index': '1', 'animation': 'summon-aura ${cssNumber(_loop)}s linear infinite'},
    ),
    // A size container, for its sparkles' places (see [summonSparkles]).
    css('.summon-sparkles').styles(
      raw: {
        'container-type': 'size',
        'z-index': '2',
        'animation': 'summon-sparkles ${cssNumber(_loop)}s linear infinite',
      },
    ),
    css('.summon-aura-glow, .summon-aura-line').styles(raw: {'position': 'absolute'}),
    css('.summon-aura-glow').styles(
      raw: {
        'inset': '-3px',
        'border': '6px solid $_glow',
        'border-radius': '12px',
        'filter': 'blur(6px)',
      },
    ),
    css('.summon-aura-line').styles(
      raw: {
        'inset': '-1px',
        'border': '2px solid $_highlight',
        'border-radius': '10px',
      },
    ),
    // Around the window while it closes, then while it's summoned back.
    css.keyframes('summon-aura', {..._auraVisit(_save, _closed), ..._auraVisit(_summon, _fade)}),
    css.keyframes('summon-sparkles', {..._sparklesVisit(_save, _closed), ..._sparklesVisit(_summon, _fade)}),

    // The window.
    css('.chrome').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        'display': 'flex',
        'flex-direction': 'column',
        'overflow': 'hidden',
        'border-radius': '9px',
        'background': '#fff',
        'color': '#202124',
        'box-shadow': '0 0 0 0.5px rgba(0, 0, 0, 0.5), 0 14px 40px rgba(4, 0, 12, 0.65)',
        'animation': 'summon-window ${cssNumber(_loop)}s linear infinite',
      },
    ),
    css.keyframes('summon-window', {
      _at(_close): Styles(raw: {'opacity': '1', 'scale': '1'}),
      _at(_closed): Styles(raw: {'opacity': '0', 'scale': '0.97'}),
      _at(_appear): Styles(raw: {'opacity': '0', 'scale': '0.985'}),
      _at(_shown): Styles(raw: {'opacity': '1', 'scale': '1'}),
    }),

    // Tabs, with the close, minimize, and zoom buttons.
    css('.chrome-tabs').styles(
      raw: {
        'display': 'flex',
        'align-items': 'flex-end',
        'flex': 'none',
        'height': '3em',
        'padding': '0 0.8em',
        'background': '#dee1e6',
      },
    ),
    css('.chrome-lights').styles(
      raw: {'display': 'flex', 'gap': '0.6em', 'align-self': 'center', 'margin': '0 1.2em 0 0.3em'},
    ),
    css('.chrome-lights i').styles(
      raw: {
        'position': 'relative',
        'width': '1.05em',
        'height': '1.05em',
        'border-radius': '50%',
        'background': '#ff5f57',
        'box-shadow': 'inset 0 0 0 0.5px rgba(0, 0, 0, 0.15)',
      },
    ),
    css('.chrome-lights i:nth-child(2)').styles(raw: {'background': '#febc2e'}),
    css('.chrome-lights i:nth-child(3)').styles(raw: {'background': '#28c840'}),
    // Just before the window closes, the close button is pressed: darkened
    // by black at 25% over it, the same as brightness(0.75), but faded
    // without redrawing the page.
    css('.chrome-lights i:first-child::before').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'inset': '0',
        'z-index': '1',
        'border-radius': '50%',
        'background': '#000',
        'opacity': '0',
        'animation': 'summon-press ${cssNumber(_loop)}s linear infinite',
      },
    ),
    css('.chrome-lights i:first-child::after').styles(
      raw: {
        'content': '"×"',
        'position': 'absolute',
        'inset': '0',
        'display': 'grid',
        'place-items': 'center',
        'font-size': '1em',
        'font-weight': '700',
        'line-height': '1',
        'color': 'rgba(77, 0, 0, 0.7)',
        'opacity': '0',
        'animation': 'summon-press-glyph ${cssNumber(_loop)}s linear infinite',
      },
    ),
    css.keyframes('summon-press', {
      _at(_close - 0.35): Styles(raw: {'opacity': '0'}),
      _at(_close - 0.3): Styles(raw: {'opacity': '0.25'}),
      _at(_closed): Styles(raw: {'opacity': '0.25'}),
      _at(_closed + 0.01): Styles(raw: {'opacity': '0'}),
    }),
    css.keyframes('summon-press-glyph', {
      _at(_close - 0.9): Styles(raw: {'opacity': '0'}),
      _at(_close - 0.75): Styles(raw: {'opacity': '1'}),
      _at(_closed): Styles(raw: {'opacity': '1'}),
      _at(_closed + 0.01): Styles(raw: {'opacity': '0'}),
    }),
    css('.chrome-tab').styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'gap': '0.55em',
        'width': '12.5em',
        'height': '2.4em',
        'padding': '0 0.8em',
        'border-radius': '0.65em 0.65em 0 0',
        'font-size': '0.95em',
        'color': '#5f6368',
        'white-space': 'nowrap',
      },
    ),
    css('.chrome-tab.active').styles(raw: {'background': '#fff', 'color': '#202124'}),
    css('.chrome-tab:not(.active)').styles(raw: {'position': 'relative'}),
    css('.chrome-tab:not(.active)::after').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'right': '0',
        'top': '0.6em',
        'bottom': '0.6em',
        'width': '1px',
        'background': '#a5a9ae',
      },
    ),
    css('.chrome-favicon').styles(
      raw: {
        'flex': 'none',
        'width': '1.15em',
        'height': '1.15em',
        'border-radius': '0.25em',
        'background': 'linear-gradient(135deg, #e8a43a, #b8562a)',
      },
    ),
    css('.chrome-favicon.moon').styles(
      raw: {'border-radius': '50%', 'background': 'radial-gradient(circle at 35% 35%, #f3f0e6, #a7a19a)'},
    ),
    css('.chrome-tab-title').styles(raw: {'flex': '1', 'overflow': 'hidden', 'text-overflow': 'ellipsis'}),
    css('.chrome-tab-close').styles(raw: {'color': '#5f6368', 'font-size': '1.2em', 'line-height': '1'}),
    css('.chrome-new-tab').styles(
      raw: {
        'align-self': 'center',
        'margin-left': '0.7em',
        'color': '#5f6368',
        'font-size': '1.4em',
        'line-height': '1',
      },
    ),

    // Back, forward, reload, the address, and the profile picture.
    css('.chrome-toolbar').styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'gap': '0.9em',
        'flex': 'none',
        'height': '3em',
        'padding': '0 1em',
        'border-bottom': '1px solid #e3e3e3',
      },
    ),
    css('.chrome-nav').styles(raw: {'flex': 'none', 'width': '5.6em', 'height': '1.5em', 'color': '#5f6368'}),
    css('.chrome-omnibox').styles(
      raw: {
        'flex': '1',
        'display': 'flex',
        'align-items': 'center',
        'gap': '0.7em',
        'min-width': '0',
        'height': '2.15em',
        'padding': '0 1em',
        'border-radius': '1.1em',
        'background': '#f1f3f4',
        'font-size': '0.95em',
        'white-space': 'nowrap',
        'overflow': 'hidden',
      },
    ),
    css('.chrome-lock').styles(raw: {'flex': 'none', 'width': '0.85em', 'height': '1em', 'color': '#5f6368'}),
    css('.chrome-profile').styles(
      raw: {
        'flex': 'none',
        'width': '1.6em',
        'height': '1.6em',
        'border-radius': '50%',
        'background': 'linear-gradient(135deg, #8c5cf0, #e070b0)',
      },
    ),

    // The made-up web page.
    css('.chrome-page').styles(
      raw: {'flex': '1', 'min-height': '0', 'padding': '1.1em 1.6em', 'background': '#fbf8f2', 'overflow': 'hidden'},
    ),
    css('.page-masthead').styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'space-between',
        'padding-bottom': '0.75em',
        'border-bottom': '1.5px solid #2a2320',
      },
    ),
    css('.page-logo').styles(
      raw: {
        'font': '700 1.5em/1 "New York", "Iowan Old Style", Georgia, serif',
        'letter-spacing': '-0.01em',
        'color': '#2a2320',
      },
    ),
    css('.page-nav').styles(raw: {'display': 'flex', 'gap': '0.8em'}),
    css('.page-nav i, .page-text i').styles(
      raw: {'display': 'block', 'height': '0.55em', 'border-radius': '0.3em', 'background': '#d9d2c7'},
    ),
    css('.page-nav i').styles(raw: {'width': '3.4em'}),
    css('.page-article').styles(
      raw: {'display': 'flex', 'gap': '1.3em', 'margin-top': '1.1em'},
    ),
    css('.page-photo').styles(
      raw: {
        'position': 'relative',
        'flex': 'none',
        'width': '38%',
        'aspect-ratio': '4 / 3',
        'overflow': 'hidden',
        'border-radius': '0.4em',
        'background': 'linear-gradient(#1c1d44, #4a3b6e 62%, #23304a 62%, #121a2c)',
      },
    ),
    css('.page-moon').styles(
      raw: {
        'position': 'absolute',
        'right': '18%',
        'top': '14%',
        'width': '15%',
        'aspect-ratio': '1',
        'border-radius': '50%',
        'background': '#f4ecd2',
        'box-shadow': '0 0 1.5em rgba(244, 236, 210, 0.5)',
      },
    ),
    // A lighthouse: a tapering tower with a lit lamp on top.
    css('.page-tower').styles(
      raw: {
        'position': 'absolute',
        'left': '26%',
        'bottom': '30%',
        'width': '11%',
        'height': '46%',
        'background': 'repeating-linear-gradient(#e9e2d6 0 22%, #b6493a 22% 40%)',
        'clip-path': 'polygon(28% 0, 72% 0, 100% 100%, 0 100%)',
      },
    ),
    css('.page-tower::before').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'inset': '0',
        'height': '14%',
        'background': '#ffd877',
      },
    ),
    css('.page-text').styles(
      raw: {'flex': '1', 'display': 'flex', 'flex-direction': 'column', 'gap': '0.6em', 'min-width': '0'},
    ),
    css('.page-kicker').styles(
      raw: {
        'font-size': '0.8em',
        'font-weight': '700',
        'letter-spacing': '0.1em',
        'text-transform': 'uppercase',
        'color': '#b6493a',
      },
    ),
    css('.page-headline').styles(
      raw: {
        'margin-bottom': '0.3em',
        'font': '700 1.25em/1.15 "New York", "Iowan Old Style", Georgia, serif',
        'color': '#2a2320',
      },
    ),
    css('.page-text i.short').styles(raw: {'width': '60%'}),

    // With Reduce Motion on: the window stays, and Séance's border with it
    // (the hero hides the sparkles).
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.chrome, .chrome-lights i::before, .chrome-lights i::after, .summon-sparkles').styles(
        raw: {'animation': 'none'},
      ),
      css('.summon-aura').styles(raw: {'animation': 'none', 'opacity': '1'}),
    ]),
  ];
}
