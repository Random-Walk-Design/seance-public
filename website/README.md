# Séance website

The marketing site for Séance, built with [Jaspr](https://jaspr.site) as a statically pre-rendered site (plain HTML and CSS, no client-side JavaScript; animations are CSS). Published to <https://seance.randomwalk.design> by `.github/workflows/deploy-site.yml` on every push to `main`.

## Development

```bash
dart pub global activate jaspr_cli 0.23.5
```

```bash
jaspr serve
```

Then open <http://localhost:8080>. To check the exact files that will be published:

```bash
jaspr build
```

The output is in `build/jaspr`.

## Layout

- `lib/pages/` — one component per page; add routes in `lib/app.dart`.
- `lib/components/hero.dart` — the home page's hero: a Mac window wearing the border and sparkles Séance puts around windows it summons. The effect copies the app's (`seance/Panel/WindowHighlighter.swift` and `SparkleView.swift` in the seance repo) in CSS; change them together.
- `lib/components/summon_stage.dart` — the dark stage the feature pictures play on (like the hero's background), and the hero's sparkles placed around any box.
- `lib/components/summon_demo.dart` — the "Save Windows & Summon Back" picture: a Chrome-like window that Séance closes and summons back.
- `lib/components/menu_bar_demo.dart` — the "Always Available" picture: a pointer opens Séance from the menu bar, names the Space, and clicks Save & Close. Its panel is a small drawing of the app's (`PanelView.swift` in the seance repo); keep its labels in step.
- `lib/components/app_summons.dart` — the "Trained on Real Apps" picture: Séance summons each app strip logo in turn, forever. It reads the app strip's list, so a new app appears in both.
- `lib/components/site_footer.dart` — the footer: "Designed and built by Random Walk Design", linking to randomwalk.design.
- `lib/releases.dart` — reads the update feed when the site is built. The home page's downloads come from it, so each release (which updates the feed and redeploys the site) appears on its own, with nothing to edit here.
- `lib/components/app_strip.dart` — the row of logos of the apps Séance works with (a sliding carousel when the window is too narrow for them all). The logos are single-color SVGs in `web/logos/`; add one there and its name in the component when Séance learns a new app.
- `lib/constants/theme.dart` — colors (light and dark) and global styles.
- `web/` — copied into the site as-is (favicon, images).
- `lib/mark.dart` — Séance's mark (a large star with two companions), the one icon that represents Séance. It matches the app's menu bar icon (`seance/Panel/SeanceMark.swift` in the seance repo) and `web/favicon.svg`; change all three together. Never use a single star, or Apple's SF Symbols (their license forbids using them as a logo).
- `web/releases/appcast.xml` — **Séance's update feed. Never move, rename, or delete it**; installed copies of Séance read it at `/releases/appcast.xml`. It's written by Séance's release workflow, not by hand.

## Interactive components

The site ships no JavaScript. If a page ever needs client-side interactivity, restore Jaspr's client entry point (`lib/main.client.dart`, created by `jaspr create`) and mark the interactive components with `@client`.

## Animation performance

The page runs hundreds of sparkle animations at once. Each sparkle is one element that moves through its three lives in turn (`sparkleElement` in `lib/components/hero.dart`); one element per life drew the same but tripled the animations, and scrolling into the hero stuttered. Animate only `opacity`, `translate`, `scale`, and `rotate` (or `transform`), which the browser runs off the main thread. A single animation of anything else (`max-width`, `box-shadow`, `filter`, `visibility`, …) makes Chrome restyle every running animation on the page each frame, which cost about 40% of a CPU core. To show a change like that, fade in an element that already has it: the menu bar demo's focus ring, and the black overlays standing in for `brightness()` on pressed buttons, work this way. Don't give the hero (or the feature pictures) `content-visibility: auto`: it saves a little while they're offscreen, but redrawing them all at once when they scroll back in makes scrolling stutter.
