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


class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
