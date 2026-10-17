/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

import 'app.dart';
import 'constants/theme.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  runApp(Document(
    title: 'Séance',
    lang: 'en',
    meta: {
      'description': 'Séance saves the windows in a Mac Space, closes them, and summons them back exactly where they were.',
      'color-scheme': 'light dark',
    },
    head: [
      link(rel: 'icon', href: '/favicon.svg', type: 'image/svg+xml'),
    ],
    styles: themeStyles,
    body: App(),
  ));
}
