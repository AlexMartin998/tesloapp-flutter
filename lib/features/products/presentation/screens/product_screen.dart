import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




// vamos a W como en la Web, solo recibimos el ID y hacemos la Req. Asi esto tb funcionaria en la web
class ProductScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  @override
  ProductScreenState createState() => ProductScreenState();
}


class ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Create product"),
      ),

      body: Center(
        child: Text(widget.productId),
      ),
    );
  }
}