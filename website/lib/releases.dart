import 'dart:io';

import 'package:xml/xml.dart';

/// Séance's update feed, which the release process updates with each
/// release. The site reads it when it's built (which happens on every
/// release), so the download page always lists what's released.
const feedPath = 'web/releases/appcast.xml';

const _sparkle = 'http://www.andymatuschak.org/xml-namespaces/sparkle';

enum Channel {
  stable('Stable'),
  beta('Beta'),
  alpha('Alpha');

  const Channel(this.title);
  final String title;
}

/// One release, as listed in the update feed.
class Release {
  const Release({
    required this.version,
    required this.build,
    required this.channel,
    required this.date,
    required this.minimumMacOS,
    required this.downloadUrl,
    required this.notesHtml,
  });

  /// As people see it, e.g. "0.2.0 beta 1".
  final String version;

  /// Sparkle's build number, which orders releases (see Séance's
  /// scripts/release/appcast.py).
  final int build;
  final Channel channel;
  final DateTime? date;

  /// E.g. "15.0".
  final String minimumMacOS;

  /// The disk image people install from (the feed itself lists the update
  /// zip, which sits next to it in the same GitHub Release).
  final Uri downloadUrl;

  /// Written by the release script from plain-text notes, with everything
  /// escaped, so it's safe to show as HTML. Null when there are none.
  final String? notesHtml;

  /// "October 18, 2026".
  String? get formattedDate {
    final date = this.date;
    if (date == null) return null;
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', //
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// "macOS 15 or later" (dropping a trailing ".0").
  String get requirement => 'macOS ${minimumMacOS.replaceFirst(RegExp(r'\.0$'), '')} or later';
}

/// Every release in the feed, newest first. Empty if there's no feed yet.
List<Release> loadReleases() {
  final file = File(feedPath);
  if (!file.existsSync()) return [];

  final releases = <Release>[];
  for (final item in XmlDocument.parse(file.readAsStringSync()).findAllElements('item')) {
    String? sparkle(String name) => item.getElement(name, namespaceUri: _sparkle)?.innerText.trim();

    final enclosure = item.getElement('enclosure')?.getAttribute('url');
    final version = sparkle('shortVersionString');
    final build = int.tryParse(sparkle('version') ?? '');
    if (enclosure == null || version == null || build == null) continue;

    final updateUrl = Uri.parse(enclosure);
    final notes = item.getElement('description')?.innerText.trim();
    releases.add(Release(
      version: version,
      build: build,
      channel: Channel.values.firstWhere(
        (channel) => channel.name == sparkle('channel'),
        orElse: () => Channel.stable,
      ),
      date: _parseDate(item.getElement('pubDate')?.innerText.trim()),
      minimumMacOS: sparkle('minimumSystemVersion') ?? '15.0',
      downloadUrl: updateUrl.replace(
        pathSegments: [...updateUrl.pathSegments.take(updateUrl.pathSegments.length - 1), 'Seance.dmg'],
      ),
      notesHtml: notes == null || notes.isEmpty ? null : notes,
    ));
  }

  releases.sort((a, b) => b.build.compareTo(a.build));
  return releases;
}

DateTime? _parseDate(String? text) {
  if (text == null) return null;
  try {
    return HttpDate.parse(text);
  } on HttpException {
    return null;
  }
}
