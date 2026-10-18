import 'package:jaspr/dom.dart';

/// Séance's colors, as CSS custom properties so they can switch with the
/// visitor's light or dark mode.
const _light = {
  '--background': '#f7f5fb',
  '--text': '#1d1a24',
  '--muted': '#5f5870',
  '--accent': '#7a3fd1',
  '--glow': 'rgba(150, 90, 240, 0.35)',
  '--on-accent': '#ffffff',
  '--surface': 'rgba(122, 63, 209, 0.08)',
  '--border': 'rgba(29, 26, 36, 0.12)',
};

const _dark = {
  '--background': '#121017',
  '--text': '#f1edf8',
  '--muted': '#a69fb8',
  '--accent': '#b98cff',
  '--glow': 'rgba(170, 110, 255, 0.4)',
  '--on-accent': '#1a1023',
  '--surface': 'rgba(185, 140, 255, 0.1)',
  '--border': 'rgba(241, 237, 248, 0.14)',
};

/// Uses macOS's own fonts, matching the app.
const _systemFont = '-apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif';

/// Global styles for the whole site.
final themeStyles = <StyleRule>[
  css(':root').styles(raw: _light),
  css.media(const MediaQuery.all(prefersColorScheme: ColorScheme.dark), [
    css(':root').styles(raw: _dark),
  ]),
  css('*').styles(raw: {'box-sizing': 'border-box'}),
  css('html, body').styles(
    padding: .zero,
    margin: .zero,
    raw: {
      'background': 'var(--background)',
      'color': 'var(--text)',
      'font': '17px/1.55 $_systemFont',
    },
  ),
];
