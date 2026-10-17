import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The home page. A placeholder until Séance's first public release.
class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    return main_(classes: 'home', [
      div(classes: 'mark', attributes: {'aria-hidden': 'true'}, [.text('✦')]),
      h1([.text('Séance')]),
      p(classes: 'tagline', [
        .text('Save a Mac Space and close it. Summon it back later, every window where you left it.'),
      ]),
      p(classes: 'status', [.text('Coming soon for macOS')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home', [
      css('&').styles(
        display: .flex,
        minHeight: 100.vh,
        padding: .symmetric(vertical: 48.px, horizontal: 16.px),
        flexDirection: .column,
        justifyContent: .center,
        alignItems: .center,
        textAlign: .center,
        raw: {'max-width': '34rem', 'margin': '0 auto'},
      ),
      css('.mark').styles(raw: {
        'font-size': '56px',
        'line-height': '1',
        'color': 'var(--accent)',
        'text-shadow': '0 0 28px var(--glow)',
      }),
      css('h1').styles(raw: {
        'margin': '20px 0 8px',
        'font': '700 clamp(2.4rem, 7vw, 3.4rem)/1.1 -apple-system, BlinkMacSystemFont, "SF Pro Display", sans-serif',
        'letter-spacing': '-0.02em',
      }),
      css('.tagline').styles(raw: {
        'margin': '0 0 24px',
        'font-size': '1.2rem',
        'color': 'var(--muted)',
      }),
      css('.status').styles(raw: {
        'display': 'inline-block',
        'margin': '0',
        'padding': '6px 14px',
        'border': '1px solid var(--accent)',
        'border-radius': '999px',
        'color': 'var(--accent)',
        'font-size': '0.9rem',
      }),
    ]),
  ];
}
