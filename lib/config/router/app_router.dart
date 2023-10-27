import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';

import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';




// // // Proteccion de rutas con Riverpod. Solo de Lectura
final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/login',

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
    ],



    // // Actual Routes Protection with Redirect
    // todas las rutas pasan x aqui
    redirect: ((context, state) { // state of GoRouter
      print(state.subloc);
      return null;
    })

  );
});
