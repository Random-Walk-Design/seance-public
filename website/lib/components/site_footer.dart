import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

/// The bottom of the page: who made Séance, linking to Random Walk Design
/// (in a new tab).
/// Dark purple, like the hero, in both light and dark mode.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'site-footer', [
      p(classes: 'site-footer-label', [.text('Designed and built by')]),
      a(
        href: 'https://randomwalk.design',
        target: Target.blank,
        classes: 'site-footer-name',
        attributes: {'rel': 'noopener'},
        [.text('Random Walk Design')],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer').styles(
      raw: {
        ...darkColors,
        'margin-top': '120px',
        'padding': '96px 24px',
        'background': '#0c0618',
        'border-top': '1px solid var(--border)',
        'color': 'var(--text)',
        'text-align': 'center',
      },
    ),
    css('.site-footer-label').styles(
      raw: {
        'margin': '0 0 10px',
        'color': 'var(--muted)',
        'font-size': '0.75rem',
        'font-weight': '600',
        'letter-spacing': '0.16em',
        'text-transform': 'uppercase',
      },
    ),
    css('.site-footer-name').styles(
      raw: {
        'color': 'var(--text)',
        'font': '700 1.5rem/1.2 -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
        'letter-spacing': '-0.01em',
        'text-decoration': 'none',
      },
    ),
    css('.site-footer-name:hover').styles(raw: {'color': 'var(--accent)'}),
    css('.site-footer-name:focus-visible').styles(
      raw: {
        'outline': '3px solid var(--accent)',
        'outline-offset': '4px',
        'border-radius': '4px',
      },
    ),
    css.media(const MediaQuery.raw('(max-width: 760px)'), [
      css('.site-footer').styles(raw: {'margin-top': '80px', 'padding': '72px 16px'}),
    ]),
  ];
}
