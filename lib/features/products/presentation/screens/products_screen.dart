import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';



class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      /* side menu */
      drawer: SideMenu( scaffoldKey: scaffoldKey ),

      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),

      body: const _ProductsView(),

      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
      ),
    );
  }
}



// // InfiniteScroll requires handle State | ConsumerStatefulWidget
class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}


class _ProductsViewState extends ConsumerState<_ProductsView> { // ref is global

  // infinite scroll
  final ScrollController scrollController = ScrollController();


  @override
  void initState() { // ngOnInit() :v
    super.initState(); // always first

    // inicia la http req con toda la clean arch: init fetch products
    ref.read(productsProvider.notifier).loadNextPage();

    // // // infinite scroll
    // // Listeners are executed many times (c/0.00001): tasa de refresco mobile screen 
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 360) >= scrollController.position.maxScrollExtent) {
        // dado q en el loadNextPage del Provider se setea el isLastPage cuando [] se evita req al API innecesarias
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose(); // all controller must be cleaned
  }


  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider); // return ProductsState

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        physics: const BouncingScrollPhysics(), // rebote ios/android
        crossAxisCount: 2, // # columns
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,

        controller: scrollController, // infinite scroll

        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];

          return GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }

}
