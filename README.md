# Séance (public)

The public home of [Séance](https://seance.randomwalk.design), a Mac app that saves the windows in a Space, closes them, and summons them back later. Séance's source code is private; this repo holds what's public:

- **The website**, a [Jaspr](https://jaspr.site) project in `website/`, published to <https://seance.randomwalk.design> by GitHub Pages on every push to `main`. See `website/README.md` to work on it.
- **Downloads**, as [GitHub Releases](https://github.com/Random-Walk-Design/seance-public/releases). Pre-releases are alpha and beta builds.
- **The update feed**, `website/web/releases/appcast.xml`, served at <https://seance.randomwalk.design/releases/appcast.xml>. Installed copies of Séance check it for updates.

## Rules for editing

- **Never delete or move `website/web/releases/appcast.xml`.** Every installed copy of Séance reads that exact address. The deploy workflow refuses to publish without it.
- **Don't edit the feed by hand.** Séance's release workflow (in the private repo) updates it with each release.
