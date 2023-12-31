import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';

import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';




// // // Proteccion de rutas con Riverpod. Solo de Lectura
final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',

    // // cuando cambia el Listenable vuevle a Evaluar el  redirect
    // estamos pendientes del AuthStatus y cuando cambie volvemos a evaluar el redirect
    refreshListenable: goRouterNotifier, // listenable espera 1 ChangeNotifier

    routes: [
      ///* First screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),

      GoRoute(
        path: '/product/:id',  // /product/new   to create
        builder: (context, state) => ProductScreen(
          productId: state.pathParameters['id'] ?? 'no-id',
        ),
      ),
    ],



    // // Actual Routes Protection with Redirect
    // todas las rutas pasan x aqui
    redirect: ((context, state) { // state of GoRouter

      final isGoingTo = state.matchedLocation;
      final authStatus= goRouterNotifier.authStatus;

      // se esta verificando el status
      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        // permitimos q vaya a las auth screens
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login'; // 'cause is not auth
      }

      if (authStatus == AuthStatus.authenticated) {
        // si ya esta auth NO dejarle ver auth screens
        if (isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash') return '/';
      }

      // aqui validarias basado en Roles (Authorization)

      return null;
    })

  );
});
