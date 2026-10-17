import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/home.dart';

/// The site. Each route is pre-rendered to its own static HTML page.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Router(routes: [
      Route(path: '/', title: 'Séance', builder: (context, state) => const Home()),
    ]);
  }
}
