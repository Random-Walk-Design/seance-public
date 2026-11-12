import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The apps Séance restores more than a window's position for (a browser's
/// tabs, an editor's project, a chat app's conversation), as a row of their
/// logos between the hero and the page's content.
///
/// The row is centered when it fits the window. When it doesn't, it slides
/// sideways forever, as a carousel (a second copy of the logos follows the
/// first, so there's never a gap).
///
/// Each logo is a single-color file in `web/logos/`, used as a mask so CSS
/// picks the purple. They come from Simple Icons, except Antigravity (Lobe
/// Icons) and Finder (Material Design Icons). When Séance learns a new app,
/// add its logo there and its name here.
class AppStrip extends StatelessComponent {
  const AppStrip({super.key});

  /// Each app's name and its file in `web/logos/`.
  static const _apps = [
    ('ChatGPT', 'chatgpt'),
    ('Claude', 'claude'),
    ('Antigravity', 'antigravity'),
    ('Cursor', 'cursor'),
    ('Windsurf', 'windsurf'),
    ('Visual Studio Code', 'vscode'),
    ('VSCodium', 'vscodium'),
    ('Xcode', 'xcode'),
    ('Android Studio', 'android-studio'),
    ('JetBrains IDEs', 'jetbrains'),
    ('Chrome', 'chrome'),
    ('Safari', 'safari'),
    ('Brave', 'brave'),
    ('Microsoft Edge', 'edge'),
    ('Vivaldi', 'vivaldi'),
    ('Finder', 'finder'),
    ('Slack', 'slack'),
    ('Discord', 'discord'),
    ('OBS Studio', 'obs-studio'),
    ('Rive', 'rive'),
  ];

  @override
  Component build(BuildContext context) {
    Component logos({required bool copy}) => ul(
      classes: copy ? 'copy' : null,
      attributes: {if (copy) 'aria-hidden': 'true'},
      [
        for (final (name, file) in _apps)
          li(
            attributes: {
              'style': '--logo: url(/logos/$file.svg)',
              if (!copy) ...{'role': 'img', 'aria-label': name},
              'title': name,
            },
            [],
          ),
      ],
    );

    return section(
      classes: 'app-strip',
      attributes: {'aria-label': 'Apps Séance can summon'},
      [
        h2([.text('Summon')]),
        div(classes: 'app-track', [logos(copy: false), logos(copy: true)]),
      ],
    );
  }

  // Layout, in CSS pixels.
  static const _logoSize = 28;
  static const _gap = 44;

  /// One set of logos, with the gap that follows each.
  static const _rowWidth = (_logoSize + _gap) * 20;

  /// The narrowest window the row fits in, with a little room either side.
  static const _fitsFrom = _rowWidth - _gap + 2 * 32;

  @css
  static List<StyleRule> get styles => [
    css('.app-strip').styles(
      raw: {
        'overflow': 'hidden',
        'padding': '9px 0 24px',
        'background': 'var(--strip)',
        'border-bottom': '1px solid var(--border)',
      },
    ),
    // Small capitals, set off from the logos.
    css('.app-strip h2').styles(
      raw: {
        'margin': '0 0 13px',
        'color': 'var(--muted)',
        'opacity': '0.6',
        'font-size': '0.62rem',
        'font-weight': '700',
        'letter-spacing': '0.18em',
        'text-align': 'center',
        'text-transform': 'uppercase',
      },
    ),
    css('.app-track').styles(raw: {'display': 'flex', 'justify-content': 'center'}),
    css('.app-strip ul').styles(
      raw: {
        'display': 'flex',
        'flex': 'none',
        'gap': '${_gap}px',
        'margin': '0',
        'padding': '0',
        'list-style': 'none',
      },
    ),
    css('.app-strip li').styles(
      raw: {
        'flex': 'none',
        'width': '${_logoSize}px',
        'height': '${_logoSize}px',
        'background': 'var(--accent)',
        'opacity': '0.75',
        'mask': 'var(--logo) center / contain no-repeat',
        '-webkit-mask': 'var(--logo) center / contain no-repeat',
      },
    ),
    // Only the carousel needs the second copy.
    css('.app-strip .copy').styles(raw: {'display': 'none'}),

    // Too narrow for the row: slide it. Moving the two copies left by one
    // copy's width lands exactly where it started.
    css.media(const MediaQuery.raw('(max-width: ${_fitsFrom - 1}px)'), [
      css('.app-strip').styles(
        raw: {
          // Logos fade in and out at the edges.
          'mask': 'linear-gradient(to right, transparent, #000 72px, #000 calc(100% - 72px), transparent)',
          '-webkit-mask': 'linear-gradient(to right, transparent, #000 72px, #000 calc(100% - 72px), transparent)',
        },
      ),
      css('.app-track').styles(
        raw: {
          'justify-content': 'flex-start',
          'width': 'max-content',
          'animation': 'app-strip-slide 60s linear infinite',
        },
      ),
      css('.app-strip ul').styles(raw: {'padding-right': '${_gap}px'}),
      css('.app-strip .copy').styles(raw: {'display': 'flex'}),
    ]),
    css.keyframes('app-strip-slide', {
      'to': Styles(raw: {'translate': '-50%'}),
    }),

    // With Reduce Motion on, the row scrolls by hand instead.
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.app-strip').styles(raw: {'overflow-x': 'auto'}),
      css('.app-track').styles(raw: {'animation': 'none'}),
      css('.app-strip .copy').styles(raw: {'display': 'none'}),
    ]),
  ];
}
