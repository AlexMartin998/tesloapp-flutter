import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/config/config.dart';


void main() async {

  // EnvV
  await Environment.initEnvironmentVariables();


  runApp(
    // riverpod sabra donde buscar c/provider q generemos
    const ProviderScope( // provider de Riverpod
      child: MainApp(),
    ),
  );
}


// Provider Consumer for StatelessWidget: GoRouter Proteccion de rutas
class MainApp extends ConsumerWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // dentro del    build    100pre usar   .watch()   aunq NO vaya a cambiar
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouter,

      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
