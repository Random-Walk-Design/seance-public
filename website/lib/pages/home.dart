import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/app_strip.dart';
import '../components/hero.dart';
import '../releases.dart';

/// The home page: the hero (what Séance is, and its latest download), the
/// apps it works with, then every download, read from the update feed when the site is built.
class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    final releases = loadReleases();
    return .fragment([
      Hero(release: recommendedRelease(releases)),
      const AppStrip(),
      if (releases.isNotEmpty) main_(classes: 'home', [Downloads(releases: releases)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.home').styles(
      padding: .symmetric(vertical: 56.px, horizontal: 16.px),
      raw: {'max-width': '40rem', 'margin': '0 auto'},
    ),
  ];
}

/// The recommended download's notes (its button is in the hero), newer
/// pre-releases to try, and every release.
class Downloads extends StatelessComponent {
  const Downloads({required this.releases, super.key});

  /// Newest first; not empty.
  final List<Release> releases;

  @override
  Component build(BuildContext context) {
    // The hero has this release's download button.
    final recommended = recommendedRelease(releases)!;
    // Pre-releases newer than the recommended one: the newest beta and alpha.
    final previews = [
      for (final channel in [Channel.beta, Channel.alpha])
        ?releases
            .takeWhile((release) => release != recommended)
            .where((release) => release.channel == channel)
            .firstOrNull,
    ];

    return section(
      classes: 'downloads',
      attributes: {'aria-label': 'Download'},
      [
        if (recommended.notesHtml case final notes?)
          div(classes: 'primary', [div(classes: 'notes', [RawText(notes)])]),

        if (previews.isNotEmpty)
          div(classes: 'previews', [
            h2([.text('Try what’s next')]),
            for (final release in previews)
              div(classes: 'preview', [
                a(href: '${release.downloadUrl}', [.text('Séance ${release.version}')]),
                span(classes: 'badge ${release.channel.name}', [.text(release.channel.title)]),
                p(classes: 'meta', [.text(_meta(release))]),
                p([.text(_about(release.channel))]),
              ]),
          ]),

        div(classes: 'install', [
          h2([.text('Installing')]),
          ol([
            li([
              .text('Double-click the downloaded Seance.dmg. A window opens with Séance and your Applications folder.'),
            ]),
            li([.text('Drag Séance onto the Applications folder.')]),
            li([
              .text(
                'Open Séance from your Applications folder. (You can then eject the Séance disk in Finder’s sidebar.)',
              ),
            ]),
            li([.text('Séance asks for Accessibility access, which it needs to see and move windows.')]),
          ]),
        ]),

        details(classes: 'all', [
          summary([.text('All releases (${releases.length})')]),
          ul([
            for (final release in releases)
              li([
                div(classes: 'release', [
                  a(href: '${release.downloadUrl}', [.text('Séance ${release.version}')]),
                  if (release.channel != Channel.stable)
                    span(classes: 'badge ${release.channel.name}', [.text(release.channel.title)]),
                ]),
                p(classes: 'meta', [.text(_meta(release))]),
                if (release.notesHtml case final notes?) div(classes: 'notes', [RawText(notes)]),
              ]),
          ]),
        ]),
      ],
    );
  }

  /// "October 18, 2026 · macOS 15 or later".
  static String _meta(Release release) => release.summary;

  /// What to expect from a channel's releases (the same as in Séance's
  /// Settings).
  static String _about(Channel channel) => switch (channel) {
    Channel.stable => 'Stable releases are finished releases.',
    Channel.beta => 'Betas let you try new features before they’re released. Usually solid.',
    Channel.alpha => 'Alphas are the earliest builds. Expect rough edges.',
  };

  @css
  static List<StyleRule> get styles => [
    css('.downloads').styles(raw: {'display': 'flex', 'flex-direction': 'column', 'gap': '40px'}),
    css('.primary').styles(raw: {'text-align': 'center'}),
    css('.downloads a:focus-visible').styles(
      raw: {
        'outline': '3px solid var(--accent)',
        'outline-offset': '3px',
      },
    ),
    css('.meta').styles(raw: {'margin': '10px 0 0', 'color': 'var(--muted)', 'font-size': '0.9rem'}),
    css('.notes').styles(raw: {'text-align': 'left', 'font-size': '0.95rem'}),
    css('.primary .notes').styles(raw: {'max-width': '30rem', 'margin': '0 auto'}),
    css('.notes p, .notes ul').styles(raw: {'margin': '8px 0'}),
    css('h2').styles(raw: {'margin': '0 0 12px', 'font-size': '1.15rem'}),
    css('.preview').styles(raw: {'margin': '0 0 12px'}),
    css('.preview p').styles(raw: {'margin': '2px 0 0', 'color': 'var(--muted)', 'font-size': '0.9rem'}),
    css('.downloads a:not(.button)').styles(raw: {'color': 'var(--accent)', 'font-weight': '600'}),
    css('.badge').styles(
      raw: {
        'margin-left': '8px',
        'padding': '1px 8px',
        'border-radius': '999px',
        'border': '1px solid currentColor',
        'font-size': '0.75rem',
        'color': 'var(--muted)',
        'vertical-align': '2px',
      },
    ),
    css('.install ol').styles(raw: {'margin': '0 0 12px', 'padding-left': '1.4em'}),
    css('.install p').styles(raw: {'margin': '0', 'color': 'var(--muted)'}),
    css('.all summary').styles(raw: {'cursor': 'pointer', 'font-weight': '600'}),
    css('.all > ul').styles(raw: {'list-style': 'none', 'margin': '12px 0 0', 'padding': '0'}),
    css('.all > ul > li').styles(raw: {'padding': '14px 0', 'border-top': '1px solid var(--border)'}),
    css('.all .meta').styles(raw: {'margin-top': '2px'}),
  ];
}
