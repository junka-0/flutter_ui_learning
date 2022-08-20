import 'package:flutter_ui_learning/studies/bounce_animation/bounce_animation_screen.dart';
import 'package:flutter_ui_learning/studies/menu_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: AppRouter.initialLocation,
    routes: AppRouter.routes,
  ),
);

class AppRouter {
  static final initialLocation = menu.path;

  static final routes = [
    menu,
    bounceAnimation,
  ];

  static final menu = GoRoute(
    name: 'menu',
    path: '/menu',
    builder: (context, state) => const MenuScreen(),
  );

  static final bounceAnimation = GoRoute(
    name: 'bounceAnimation',
    path: '/bounceAnimation',
    builder: (context, state) => const BounceAnimationScreen(),
  );
}
