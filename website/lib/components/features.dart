import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'app_summons.dart';
import 'menu_bar_demo.dart';
import 'summon_demo.dart';

/// Alternating left/right feature sections above the ultrawide monitor strip.
///
/// Each section has a heading, a brief description, and a cutout on the
/// opposite side, translated outward beyond the text column line, that holds
/// the section's picture.
class Features extends StatelessComponent {
  const Features({super.key});

  static const _features = [
    (
      title: 'Save Windows & Summon Back',
      body:
          'Need to free up space? Don’t worry about re-opening your windows. '
          'Save every window position in your Space with Séance, and then '
          'summon them back later, when you’re ready.',
      visual: SummonDemo(),
    ),
    (
      title: 'Always Available',
      body:
          'Séance is always available from your menu bar. Close or summon a '
          'Space at any moment.',
      visual: MenuBarDemo(),
    ),
    (
      title: 'Trained on Real Apps',
      body:
          'Every app opens and closes differently. Some apps open to a '
          'specified project, or directory, or chat thread. Séance has been '
          'trained against a variety of real apps, including Chrome, Discord, '
          'Slack, XCode, VSCode, and more.',
      visual: AppSummons(),
    ),
  ];

  @override
  Component build(BuildContext context) {
    return section(
      classes: 'features',
      attributes: {'aria-label': 'Features'},
      [
        for (final (index, feature) in _features.indexed)
          div(
            classes: 'feature-row${index.isOdd ? ' reverse' : ''}',
            [
              div(classes: 'feature-copy', [
                h2([.text(feature.title)]),
                p([.text(feature.body)]),
              ]),
              div(
                classes: 'feature-cutout',
                attributes: {'aria-hidden': 'true'},
                [feature.visual],
              ),
            ],
          ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.features').styles(
      raw: {
        'max-width': '62rem',
        'margin': '0 auto',
        'padding': '72px 24px 0',
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '144px',
      },
    ),
    css('.feature-row').styles(
      raw: {
        'display': 'grid',
        'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
        'gap': '48px',
        'align-items': 'center',
      },
    ),
    css('.feature-row:not(.reverse) .feature-cutout').styles(
      raw: {'translate': '120px 0'},
    ),
    css('.feature-row.reverse .feature-copy').styles(
      raw: {'order': '2'},
    ),
    css('.feature-row.reverse .feature-cutout').styles(
      raw: {
        'order': '1',
        'translate': '-120px 0',
      },
    ),
    css('.feature-copy h2').styles(
      raw: {
        'margin': '0 0 14px',
        'font':
            '700 clamp(1.45rem, 2.8vw, 1.85rem)/1.2 -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
        'letter-spacing': '-0.015em',
      },
    ),
    css('.feature-copy p').styles(
      raw: {
        'margin': '0',
        'color': 'var(--muted)',
        'font-size': '1.05rem',
        'line-height': '1.6',
      },
    ),
    css('.feature-cutout').styles(
      raw: {
        'position': 'relative',
        'aspect-ratio': '16 / 10',
        'border-radius': '16px',
        'background': 'var(--surface)',
        'border': '1px dashed var(--border)',
      },
    ),
    css.media(const MediaQuery.raw('(max-width: 1280px)'), [
      css('.feature-row:not(.reverse) .feature-cutout').styles(
        raw: {'translate': '48px 0'},
      ),
      css('.feature-row.reverse .feature-cutout').styles(
        raw: {'translate': '-48px 0'},
      ),
    ]),
    css.media(const MediaQuery.raw('(max-width: 1080px)'), [
      css('.feature-row:not(.reverse) .feature-cutout').styles(
        raw: {'translate': '0'},
      ),
      css('.feature-row.reverse .feature-cutout').styles(
        raw: {'translate': '0'},
      ),
    ]),
    css.media(const MediaQuery.raw('(max-width: 760px)'), [
      css('.features').styles(
        raw: {
          'padding': '48px 16px 0',
          'gap': '80px',
        },
      ),
      css('.feature-row').styles(
        raw: {
          'grid-template-columns': '1fr',
          'gap': '20px',
        },
      ),
      css('.feature-row.reverse .feature-copy').styles(
        raw: {'order': '1'},
      ),
      css('.feature-row.reverse .feature-cutout').styles(
        raw: {'order': '2'},
      ),
    ]),
  ];
}
