import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../mark.dart';
import 'summon_stage.dart';

/// The picture for "Always Available": the right end of a Mac menu bar, with
/// Séance's icon among the others. A pointer moves to Séance and clicks it,
/// Séance's panel opens, the pointer clicks the Space name field and a name
/// is typed, then it clicks Save & Close, the panel closes, and the pointer
/// goes back to where it started. It loops.
///
/// The panel is a small drawing of Séance's (`PanelView.swift` in the seance
/// repo): "This Space", a sketch of the Space's windows, the name field and
/// Save & Close, and the saved Spaces below. It plays on a [SummonStage].
/// All CSS, because the site has no JavaScript.
///
/// Everything is placed in the stage's container units, so the pointer's
/// targets below line up with what's drawn at any size.
class MenuBarDemo extends StatelessComponent {
  const MenuBarDemo({super.key});

  /// The name typed into the field.
  static const _name = 'Research';

  @override
  Component build(BuildContext context) {
    return SummonStage(
      children: [
        div(classes: 'mb-bar', [
          span(classes: 'mb-item mb-cloud', [RawText(_cloudIcon)]),
          span(classes: 'mb-item mb-seance', [
            span(classes: 'mb-pressed', []),
            RawText('<svg viewBox="0 0 24 24"><path fill="currentColor" d="${markPath()}"/></svg>'),
          ]),
          span(classes: 'mb-item mb-wifi', [RawText(_wifiIcon)]),
          span(classes: 'mb-item mb-battery', [RawText(_batteryIcon)]),
          span(classes: 'mb-item mb-toggles', [RawText(_togglesIcon)]),
          span(classes: 'mb-clock', [.text('Sun 9:41 AM')]),
        ]),
        div(classes: 'mb-panel', [
          div(classes: 'mb-panel-header', [
            span([.text('This Space')]),
            span(classes: 'mb-panel-buttons', [i([]), i([]), i([])]),
          ]),
          div(classes: 'mb-panel-screen', [i([]), i([]), i([])]),
          div(classes: 'mb-panel-count', [.text('3 windows')]),
          div(classes: 'mb-panel-row', [
            div(classes: 'mb-field', [
              span(classes: 'mb-ring', []),
              div(classes: 'mb-field-text', [
                span(classes: 'mb-placeholder', [.text('Space name')]),
                span(classes: 'mb-typed', [
                  // The text cursor's place before the first letter.
                  span(classes: 'mb-start', [_caret(0)]),
                  for (final (index, char) in _name.split('').indexed)
                    span(
                      classes: 'mb-char',
                      attributes: {'style': 'animation-name:mb-char-$index'},
                      [
                        .text(char == ' ' ? ' ' : char),
                        _caret(index + 1),
                      ],
                    ),
                ]),
              ]),
            ]),
            div(classes: 'mb-save', [.text('Save & Close')]),
          ]),
          div(classes: 'mb-panel-footer', [.text('No Saved Spaces')]),
        ]),
        div(classes: 'mb-pointer', [RawText(_pointer)]),
      ],
    );
  }

  /// The text cursor where it is after [typed] letters: just right of the
  /// last one. Each place has its own cursor, shown in turn, so the letters
  /// can appear by fading in (which the browser animates without redrawing
  /// the page) rather than by growing and pushing one cursor along.
  static Component _caret(int typed) =>
      i(classes: 'mb-caret', attributes: {'style': 'animation-name:mb-caret-$typed'}, []);

  // Simple outline glyphs for the other menu bar items.

  static const _cloudIcon =
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round">'
      '<path d="M7 18h10.5a3.5 3.5 0 0 0 .4-7A5.5 5.5 0 0 0 7.3 9.6 4.2 4.2 0 0 0 7 18z"/></svg>';

  static const _wifiIcon =
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">'
      '<path d="M3 9.5a13 13 0 0 1 18 0M6.2 13a8.5 8.5 0 0 1 11.6 0M9.4 16.4a4 4 0 0 1 5.2 0"/>'
      '<circle cx="12" cy="19.4" r="1.2" fill="currentColor" stroke="none"/></svg>';

  static const _batteryIcon =
      '<svg viewBox="0 0 30 24" fill="none" stroke="currentColor" stroke-width="1.5">'
      '<rect x="2" y="7" width="23" height="10" rx="3"/>'
      '<rect x="4" y="9" width="15" height="6" rx="1.5" fill="currentColor" stroke="none"/>'
      '<path d="M27 10.5v3" stroke-width="2" stroke-linecap="round"/></svg>';

  static const _togglesIcon =
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">'
      '<rect x="3" y="5" width="18" height="6" rx="3"/><rect x="3" y="13" width="18" height="6" rx="3"/>'
      '<circle cx="15" cy="8" r="1.6" fill="currentColor"/><circle cx="9" cy="16" r="1.6" fill="currentColor"/></svg>';

  /// An arrow pointer, its tip at the top left.
  static const _pointer =
      '<svg viewBox="0 0 16 24"><path d="M1.5 1.5v17.2l4.3-4.1 2.9 6.6 2.9-1.3-2.8-6.4h6z" '
      'fill="#000" stroke="#fff" stroke-width="1.3" stroke-linejoin="round"/></svg>';

  // Where things are, in container units (x in cqw, y in cqh).

  static const _barHeight = 9.0;
  static const _seanceX = 52.0;

  /// The panel hangs below Séance's icon, centered on it.
  static const _panelLeft = 20.0, _panelTop = 12.0, _panelWidth = 64.0, _panelHeight = 74.0;

  /// The name field and Save & Close, within the panel.
  static const _rowTop = 51.0, _rowHeight = 8.0, _inset = 2.5, _saveWidth = 16.0;

  // The pointer's stops.
  static const _rest = (x: 30.0, y: 80.0);
  static const _icon = (x: _seanceX - 0.6, y: _barHeight / 2);
  static const _field = (x: _panelLeft + 24, y: _panelTop + _rowTop + _rowHeight / 2);
  static const _save = (
    x: _panelLeft + _panelWidth - _inset - _saveWidth / 2,
    y: _panelTop + _rowTop + _rowHeight / 2 + 0.5,
  );

  // The loop, in seconds.

  static const _loop = 9.0;
  static const _toIcon = (0.5, 1.4);
  static const _clickIcon = 1.5;
  static const _toField = (1.9, 2.6);
  static const _clickField = 2.7;
  static const _typeFrom = 2.95;
  static const _typeEach = 0.09;
  static const _toSave = (4.6, 5.2);
  static const _clickSave = 5.35;
  static const _closed = 5.6;
  static const _back = (5.9, 7.0);

  static String _at(double seconds) => '${cssNumber(seconds / _loop * 100)}%';

  static const _move = 'cubic-bezier(0.45, 0, 0.25, 1)';

  static Styles _point(({double x, double y}) at, {String? easing, double scale = 1}) => Styles(
    raw: {
      'translate': '${cssNumber(at.x)}cqw ${cssNumber(at.y)}cqh',
      'scale': cssNumber(scale),
      'animation-timing-function': ?easing,
    },
  );

  /// The pointer: moves (eased), and shrinks a little for each click.
  static Map<String, Styles> get _pointerKeyframes {
    Map<String, Styles> click(double time, ({double x, double y}) at) => {
      _at(time - 0.06): _point(at),
      _at(time): _point(at, scale: 0.85),
      _at(time + 0.08): _point(at),
    };
    return {
      '0%': _point(_rest),
      _at(_toIcon.$1): _point(_rest, easing: _move),
      _at(_toIcon.$2): _point(_icon),
      ...click(_clickIcon, _icon),
      _at(_toField.$1): _point(_icon, easing: _move),
      _at(_toField.$2): _point(_field),
      ...click(_clickField, _field),
      _at(_toSave.$1): _point(_field, easing: _move),
      _at(_toSave.$2): _point(_save),
      ...click(_clickSave, _save),
      _at(_back.$1): _point(_save, easing: _move),
      _at(_back.$2): _point(_rest),
      '100%': _point(_rest),
    };
  }

  /// Keyframes that switch something on at [from] and off at [to].
  static Map<String, Styles> _between(double from, double to, Map<String, String> on, Map<String, String> off) => {
    '0%': Styles(raw: off),
    _at(from - 0.01): Styles(raw: off),
    _at(from): Styles(raw: on),
    _at(to): Styles(raw: on),
    _at(to + 0.01): Styles(raw: off),
    '100%': Styles(raw: off),
  };

  static String _animation(String name) => '$name ${cssNumber(_loop)}s linear infinite';

  static const _font = '-apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif';

  @css
  static List<StyleRule> get styles => [
    // The menu bar: translucent, across the top, its items on the right.
    css('.mb-bar').styles(
      raw: {
        'position': 'absolute',
        'inset': '0 0 auto',
        'height': '${cssNumber(_barHeight)}cqh',
        'background': 'rgba(20, 12, 34, 0.55)',
        'backdrop-filter': 'blur(12px)',
        '-webkit-backdrop-filter': 'blur(12px)',
        'border-bottom': '1px solid rgba(255, 255, 255, 0.06)',
        'color': '#f1edf8',
        'font': '500 3.4cqh/1 $_font',
      },
    ),
    css('.mb-item').styles(
      raw: {
        'position': 'absolute',
        'top': '0',
        'width': '5.4cqw',
        'height': '100%',
        'translate': '-50%',
        'display': 'grid',
        'place-items': 'center',
      },
    ),
    css('.mb-item svg').styles(raw: {'position': 'relative', 'width': '4.6cqh', 'height': '4.6cqh'}),
    css('.mb-cloud').styles(raw: {'left': '44cqw'}),
    css('.mb-seance').styles(raw: {'left': '${cssNumber(_seanceX)}cqw'}),
    css('.mb-wifi').styles(raw: {'left': '60cqw'}),
    css('.mb-battery').styles(raw: {'left': '67.5cqw'}),
    css('.mb-battery svg').styles(raw: {'width': '5.6cqh'}),
    css('.mb-toggles').styles(raw: {'left': '75cqw'}),
    css('.mb-clock').styles(
      raw: {
        'position': 'absolute',
        'right': '3cqw',
        'top': '0',
        'height': '100%',
        'display': 'flex',
        'align-items': 'center',
        'white-space': 'nowrap',
      },
    ),
    // Séance's item looks pressed while its panel is open.
    css('.mb-pressed').styles(
      raw: {
        'position': 'absolute',
        'inset': '1cqh 0',
        'border-radius': '1.4cqh',
        'background': 'rgba(255, 255, 255, 0.22)',
        'opacity': '0',
        'animation': _animation('mb-pressed'),
      },
    ),
    css.keyframes('mb-pressed', _between(_clickIcon, _closed, {'opacity': '1'}, {'opacity': '0'})),

    // Séance's panel.
    css('.mb-panel').styles(
      raw: {
        'position': 'absolute',
        'left': '${cssNumber(_panelLeft)}cqw',
        'top': '${cssNumber(_panelTop)}cqh',
        'width': '${cssNumber(_panelWidth)}cqw',
        'height': '${cssNumber(_panelHeight)}cqh',
        'border-radius': '2.6cqh',
        'background': '#1e1e20',
        'border': '1px solid rgba(255, 255, 255, 0.13)',
        'box-shadow': '0 2cqh 6cqh rgba(0, 0, 0, 0.55)',
        'color': '#ececec',
        'font': '2.9cqh/1.2 $_font',
        'transform-origin': '${cssNumber(_seanceX - _panelLeft)}cqw 0',
        'opacity': '0',
        'animation': _animation('mb-panel'),
      },
    ),
    // The arrow pointing up at Séance's icon.
    css('.mb-panel::before').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'left': '${cssNumber(_seanceX - _panelLeft)}cqw',
        'top': '-1.3cqh',
        'width': '2.4cqh',
        'height': '2.4cqh',
        'translate': '-50%',
        'rotate': '45deg',
        'background': '#1e1e20',
        'border': '1px solid rgba(255, 255, 255, 0.13)',
        'border-right': 'none',
        'border-bottom': 'none',
      },
    ),
    css.keyframes('mb-panel', {
      '0%': Styles(raw: {'opacity': '0', 'scale': '0.96'}),
      _at(_clickIcon + 0.04): Styles(raw: {'opacity': '0', 'scale': '0.96'}),
      _at(_clickIcon + 0.24): Styles(raw: {'opacity': '1', 'scale': '1'}),
      _at(_closed - 0.2): Styles(raw: {'opacity': '1', 'scale': '1'}),
      _at(_closed): Styles(raw: {'opacity': '0', 'scale': '1'}),
      '100%': Styles(raw: {'opacity': '0', 'scale': '0.96'}),
    }),
    css('.mb-panel-header').styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'space-between',
        'height': '9cqh',
        'padding': '0 ${cssNumber(_inset)}cqw',
        'border-bottom': '1px solid rgba(255, 255, 255, 0.09)',
        'font-weight': '700',
      },
    ),
    css('.mb-panel-buttons').styles(raw: {'display': 'flex', 'gap': '1.4cqh'}),
    css('.mb-panel-buttons i').styles(
      raw: {
        'width': '2.4cqh',
        'height': '2.4cqh',
        'border-radius': '50%',
        'border': '1.5px solid #9a9a9e',
      },
    ),
    css('.mb-panel-buttons i:last-child').styles(raw: {'background': '#9a9a9e', 'border': 'none'}),
    // A sketch of the Space: its screen, with three windows.
    css('.mb-panel-screen').styles(
      raw: {
        'position': 'absolute',
        'left': '50%',
        'top': '12cqh',
        'width': '30cqw',
        'height': '27cqh',
        'translate': '-50%',
        'border-radius': '0.8cqh',
        'background': '#0e0e0f',
        'border': '1px solid rgba(255, 255, 255, 0.14)',
        'border-top': '1.4cqh solid #2c2c2e',
      },
    ),
    css('.mb-panel-screen i').styles(
      raw: {
        'position': 'absolute',
        'border-radius': '0.6cqh',
        'background': 'rgba(150, 70, 190, 0.6)',
        'border': '1px solid rgba(220, 160, 255, 0.35)',
      },
    ),
    css('.mb-panel-screen i:nth-child(1)').styles(
      raw: {'left': '6%', 'top': '8%', 'width': '40%', 'height': '52%'},
    ),
    css('.mb-panel-screen i:nth-child(2)').styles(
      raw: {'left': '52%', 'top': '14%', 'width': '42%', 'height': '38%'},
    ),
    css('.mb-panel-screen i:nth-child(3)').styles(
      raw: {'left': '30%', 'top': '56%', 'width': '36%', 'height': '36%'},
    ),
    css('.mb-panel-count').styles(
      raw: {
        'position': 'absolute',
        'inset': '41.5cqh 0 auto',
        'text-align': 'center',
        'color': '#9a9a9e',
        'font-size': '2.6cqh',
      },
    ),
    // The name field and Save & Close, between two dividers.
    css('.mb-panel-row').styles(
      raw: {
        'position': 'absolute',
        'left': '0',
        'right': '0',
        'top': '${cssNumber(_rowTop - 2)}cqh',
        'height': '${cssNumber(_rowHeight + 4)}cqh',
        'display': 'flex',
        'align-items': 'center',
        'gap': '2cqw',
        'padding': '0 ${cssNumber(_inset)}cqw',
        'border-top': '1px solid rgba(255, 255, 255, 0.09)',
        'border-bottom': '1px solid rgba(255, 255, 255, 0.09)',
      },
    ),
    css('.mb-field').styles(
      raw: {
        'position': 'relative',
        'flex': '1',
        'height': '${cssNumber(_rowHeight - 1)}cqh',
        'border-radius': '1cqh',
        'background': '#2a2a2d',
      },
    ),
    // The focus ring, faded in and out (rather than animating the field's
    // shadow, which the browser would redraw every frame).
    css('.mb-ring').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        'border-radius': 'inherit',
        'box-shadow': '0 0 0 2px rgba(10, 132, 255, 0.8)',
        'opacity': '0',
        'animation': _animation('mb-focus'),
      },
    ),
    css.keyframes('mb-focus', _between(_clickField, _closed, {'opacity': '1'}, {'opacity': '0'})),
    css('.mb-field-text').styles(
      raw: {
        'position': 'relative',
        'display': 'flex',
        'align-items': 'center',
        'height': '100%',
        'padding': '0 1.4cqw',
        'border-radius': 'inherit',
        'white-space': 'nowrap',
        'overflow': 'hidden',
      },
    ),
    css('.mb-placeholder').styles(
      raw: {'position': 'absolute', 'color': '#77777c', 'animation': _animation('mb-placeholder')},
    ),
    // The placeholder shows until the first letter is typed.
    css.keyframes('mb-placeholder', {
      for (final (time, opacity) in [
        (0.0, 1),
        (_typeFrom - 0.01, 1),
        (_typeFrom, 0),
        (_closed, 0),
        (_closed + 0.01, 1),
      ])
        _at(time): Styles(raw: {'opacity': '$opacity'}),
      '100%': Styles(raw: {'opacity': '1'}),
    }),
    css('.mb-typed').styles(raw: {'display': 'flex', 'align-items': 'center', 'height': '100%'}),
    // Each letter shows from when it's typed until the panel has closed.
    css('.mb-start, .mb-char').styles(raw: {'position': 'relative'}),
    css('.mb-char, .mb-caret').styles(
      raw: {
        'opacity': '0',
        'animation-duration': '${cssNumber(_loop)}s',
        'animation-timing-function': 'linear',
        'animation-iteration-count': 'infinite',
      },
    ),
    css('.mb-char').styles(raw: {'display': 'inline-block'}),
    for (var index = 0; index < _name.length; index++)
      css.keyframes(
        'mb-char-$index',
        _between(_typeFrom + index * _typeEach, _closed, {'opacity': '1'}, {'opacity': '0'}),
      ),
    // The text cursor, blinking while the field has focus: at the start
    // until the first letter is typed, then after each letter until the
    // next, then after the last until Save & Close is clicked.
    css('.mb-caret').styles(
      raw: {
        'position': 'absolute',
        'left': 'calc(100% + 0.2cqw)',
        'top': '50%',
        'width': '1.5px',
        'height': '3.4cqh',
        'margin-top': '-1.7cqh',
      },
    ),
    css('.mb-caret::before').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'inset': '0',
        'background': '#ececec',
        'animation': 'mb-blink 1s steps(1) infinite',
      },
    ),
    for (var typed = 0; typed <= _name.length; typed++)
      css.keyframes(
        'mb-caret-$typed',
        _between(
          typed == 0 ? _clickField : _typeFrom + (typed - 1) * _typeEach,
          // Hands over to the next place as its letter appears.
          typed == _name.length ? _clickSave : _typeFrom + typed * _typeEach - 0.01,
          {'opacity': '1'},
          {'opacity': '0'},
        ),
      ),
    css.keyframes('mb-blink', {
      '0%': Styles(raw: {'opacity': '1'}),
      '50%': Styles(raw: {'opacity': '0'}),
    }),
    css('.mb-save').styles(
      raw: {
        'flex': 'none',
        'width': '${cssNumber(_saveWidth)}cqw',
        'height': '${cssNumber(_rowHeight - 1)}cqh',
        'display': 'grid',
        'place-items': 'center',
        'border-radius': '1cqh',
        'background': '#0a84ff',
        'color': '#fff',
        'font-weight': '500',
        'white-space': 'nowrap',
      },
    ),
    // Darkened while it's clicked: black at 22% over it is the same as
    // brightness(0.78), but fades without redrawing the page.
    css('.mb-save').styles(raw: {'position': 'relative'}),
    css('.mb-save::after').styles(
      raw: {
        'content': '""',
        'position': 'absolute',
        'inset': '0',
        'border-radius': 'inherit',
        'background': '#000',
        'opacity': '0',
        'animation': _animation('mb-save'),
      },
    ),
    css.keyframes('mb-save', _between(_clickSave - 0.06, _clickSave + 0.12, {'opacity': '0.22'}, {'opacity': '0'})),
    css('.mb-panel-footer').styles(
      raw: {
        'position': 'absolute',
        'inset': 'auto 0 0',
        'height': '${cssNumber(_panelHeight - _rowTop - _rowHeight - 2)}cqh',
        'display': 'grid',
        'place-items': 'center',
        'color': '#9a9a9e',
      },
    ),

    // The pointer, its tip at the point it's moved to.
    css('.mb-pointer').styles(
      raw: {
        'position': 'absolute',
        'left': '0',
        'top': '0',
        'width': '4.2cqh',
        'height': '6.3cqh',
        'margin': '-0.3cqh 0 0 -0.4cqh',
        'transform-origin': '0.4cqh 0.3cqh',
        'filter': 'drop-shadow(0 0.4cqh 0.6cqh rgba(0, 0, 0, 0.45))',
        'animation': _animation('mb-pointer'),
      },
    ),
    // As on a Mac, the pointer hides while typing, until it moves again.
    css('.mb-pointer svg').styles(
      raw: {'display': 'block', 'width': '100%', 'height': '100%', 'animation': _animation('mb-pointer-typing')},
    ),
    css.keyframes('mb-pointer-typing', _between(_typeFrom, _toSave.$1 - 0.01, {'opacity': '0'}, {'opacity': '1'})),
    css.keyframes('mb-pointer', _pointerKeyframes),

    // With Reduce Motion on: the panel, open, with the name typed.
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css(
        '.mb-pointer, .mb-pointer svg, .mb-pressed, .mb-panel, .mb-ring, .mb-placeholder, .mb-char, .mb-caret, '
        '.mb-caret::before, .mb-save::after',
      ).styles(raw: {'animation': 'none'}),
      css('.mb-pointer').styles(raw: {'translate': '${cssNumber(_save.x)}cqw ${cssNumber(_save.y)}cqh'}),
      css('.mb-pressed, .mb-panel').styles(raw: {'opacity': '1'}),
      css('.mb-placeholder').styles(raw: {'display': 'none'}),
      css('.mb-char').styles(raw: {'opacity': '1'}),
    ]),
  ];
}
