import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/transactions/presentation/pages/add_edit_page.dart';
import '../features/transactions/presentation/pages/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddEditPage(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) =>
                AddEditPage(id: state.pathParameters['id']),
          ),
        ],
      ),
    ],
    observers: [_NavObserver()],
  );
});

class _NavObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {}
}
