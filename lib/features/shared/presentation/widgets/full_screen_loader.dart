import 'package:flutter/material.dart';


class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});


  @override
  Widget build(BuildContext context) {

    return const SizedBox.expand( // tome todo el size disponible
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
