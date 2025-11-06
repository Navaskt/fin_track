import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/security/controller/app_lock_providers.dart';
import '../core/security/presentation/lock_screen.dart';
import '../core/security/presentation/set_pin_screen.dart';
import '../features/insights/presentation/pages/insights_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/transactions/presentation/pages/add_edit_page.dart';
import '../features/transactions/presentation/pages/home_page.dart';
import 'go_router_refresh_stream.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // Rebuild router when lock state changes
  final lockCtrl = ref.watch(appLockControllerProvider.notifier);
  final lockState = ref.watch(appLockControllerProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      // Lock flow
      GoRoute(path: '/lock', builder: (context, state) => const LockScreen()),
      GoRoute(
        path: '/set-pin',
        builder: (context, state) => const SetPinScreen(),
      ),

      // App
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
          // fix: child paths shouldn't start with '/'
          GoRoute(
            path: 'insights',
            builder: (context, state) => const InsightsScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],

    // Redirect based on lock state
    redirect: (context, state) {
      final isAtLock =
          state.uri.toString() == '/lock' || state.uri.toString() == '/set-pin';

      // No PIN yet - force setup
      if (lockState == LockState.setupRequired && !isAtLock) {
        return '/lock';
      }

      // Locked - show lock
      if (lockState == LockState.locked && !isAtLock) {
        return '/lock';
      }

      // Unlocked but sitting on lock routes - send home
      if (lockState == LockState.unlocked && isAtLock) {
        return '/';
      }

      return null;
    },

    // Re-evaluate redirect when lock stream emits
    refreshListenable: GoRouterRefreshStream(lockCtrl.stream),

    // Keep your observer
    observers: [_NavObserver()],
  );
});

class _NavObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // Handle the push event
  }
}
