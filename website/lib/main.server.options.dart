// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:website/components/app_strip.dart' as _app_strip;
import 'package:website/components/app_summons.dart' as _app_summons;
import 'package:website/components/demo_monitor.dart' as _demo_monitor;
import 'package:website/components/features.dart' as _features;
import 'package:website/components/hero.dart' as _hero;
import 'package:website/components/menu_bar_demo.dart' as _menu_bar_demo;
import 'package:website/components/site_footer.dart' as _site_footer;
import 'package:website/components/summon_demo.dart' as _summon_demo;
import 'package:website/components/summon_stage.dart' as _summon_stage;
import 'package:website/pages/home.dart' as _home;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  styles: () => [
    ..._app_strip.AppStrip.styles,
    ..._app_summons.AppSummons.styles,
    ..._demo_monitor.DemoMonitor.styles,
    ..._features.Features.styles,
    ..._hero.Hero.styles,
    ..._menu_bar_demo.MenuBarDemo.styles,
    ..._site_footer.SiteFooter.styles,
    ..._summon_demo.SummonDemo.styles,
    ..._summon_stage.SummonStage.styles,
    ..._home.Downloads.styles,
    ..._home.Home.styles,
  ],
);
