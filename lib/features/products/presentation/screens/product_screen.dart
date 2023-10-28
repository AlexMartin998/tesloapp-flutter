import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/presentation/widgets/widgets.dart';


// consumer for StatelessWidgets
class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // llama al super() q invoca al loadProduct()
    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Product'),
        actions: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.camera_alt_outlined)
          ),
        ],
      ),

      body: FullScreenLoader(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

