import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The ultrawide monitor showing Séance saving and summoning a Space, set in a
/// full-bleed dark strip whose background matches the outer edges of the video.
///
/// The static first-frame poster loads immediately; the muted, looping video
/// sits directly on top of it at identical dimensions and seamlessly replaces
/// the poster once it starts playing. (A video, not an animated WebP: WebP
/// compresses each frame on its own, so the same clip was over 15× larger.)
class DemoMonitor extends StatelessComponent {
  const DemoMonitor({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      classes: 'demo-monitor',
      attributes: {'aria-label': 'Séance in action'},
      [
        div(classes: 'demo-frame', [
          img(
            src: '/seance-demo-poster.webp',
            alt: '',
            width: 1400,
            height: 558,
            classes: 'demo-poster',
            attributes: {
              'aria-hidden': 'true',
              'decoding': 'async',
              'fetchpriority': 'high',
            },
          ),
          video(
            src: '/seance-demo.mp4',
            autoplay: true,
            loop: true,
            muted: true,
            preload: Preload.auto,
            width: 1400,
            height: 558,
            classes: 'demo-anim',
            attributes: {
              'playsinline': '',
              'disablepictureinpicture': '',
              'aria-label': 'Séance saving the windows in a Mac Space and summoning them back on an ultrawide monitor.',
              'onplaying': 'this.dataset.ready=1',
            },
            [],
          ),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.demo-monitor').styles(
      raw: {
        'margin': '72px 0 24px',
        'padding': '36px 0',
        'background': '#0a0018',
        'border-top': '1px solid var(--border)',
        'border-bottom': '1px solid var(--border)',
      },
    ),
    css('.demo-frame').styles(
      raw: {
        'position': 'relative',
        'max-width': '1400px',
        'margin': '0 auto',
        'aspect-ratio': '800 / 245',
        'overflow': 'hidden',
        'background': '#0a0018',
        // Fade all four edges of the cropped video smoothly into the #0a0018 strip.
        'mask':
            'linear-gradient(to bottom, transparent, #000 32px, #000 calc(100% - 32px), transparent), '
            'linear-gradient(to right, transparent, #000 32px, #000 calc(100% - 32px), transparent)',
        '-webkit-mask':
            'linear-gradient(to bottom, transparent, #000 32px, #000 calc(100% - 32px), transparent), '
            'linear-gradient(to right, transparent, #000 32px, #000 calc(100% - 32px), transparent)',
        'mask-composite': 'intersect',
        '-webkit-mask-composite': 'source-in',
      },
    ),
    css('.demo-frame img, .demo-frame video').styles(
      raw: {
        'display': 'block',
        'width': '100%',
        'height': '100%',
        'object-fit': 'cover',
        'object-position': '50% 56%',
        'user-select': 'none',
        '-webkit-user-drag': 'none',
      },
    ),
    css('.demo-anim').styles(
      raw: {
        'position': 'absolute',
        'inset': '0',
        'opacity': '0',
      },
    ),
    css('.demo-anim[data-ready]').styles(
      raw: {
        'opacity': '1',
      },
    ),
    // Respect Reduce Motion by showing the static first frame instead of the loop.
    css.media(const MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.demo-anim').styles(raw: {'display': 'none'}),
    ]),
  ];
}
