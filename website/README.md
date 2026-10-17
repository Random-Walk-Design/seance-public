# Séance website

The marketing site for Séance, built with [Jaspr](https://jaspr.site) as a statically pre-rendered site (plain HTML and CSS, no client-side JavaScript). Published to <https://seance.randomwalk.design> by `.github/workflows/deploy-site.yml` on every push to `main`.

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
- `lib/constants/theme.dart` — colors (light and dark) and global styles.
- `web/` — copied into the site as-is (favicon, images).
- `web/releases/appcast.xml` — **Séance's update feed. Never move, rename, or delete it**; installed copies of Séance read it at `/releases/appcast.xml`. It's written by Séance's release workflow, not by hand.

## Interactive components

The site ships no JavaScript. If a page ever needs client-side interactivity, restore Jaspr's client entry point (`lib/main.client.dart`, created by `jaspr create`) and mark the interactive components with `@client`.
