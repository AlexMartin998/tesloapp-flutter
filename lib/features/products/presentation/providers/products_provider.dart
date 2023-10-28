import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';



// // // StateNotifierProvider to be used with StateNotifier
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});



// // // State Notifier: Generico para varios Providers de != useCases
class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productsRepository;


  // constructor always is Sync
  ProductsNotifier({
    required this.productsRepository,
  }) : super(ProductsState()) {
    // a penas se cree la 1ra instancia d este Notifier, load products
    loadNextPage();
  }



  Future loadNextPage() async {
    // isLastPage avoids unnecessary requests
    if (state.isLoading || state.isLastPage) return;
    state = state.copyWith(isLoading: true);

    final producst = await productsRepository
      .getProductsByPage(limit: state.limit, offset: state.offset);

    if (producst.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true // isLastPage avoids unnecessary requests
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...producst]
    );
  }

}



// // // State: Con Riverpod NO es indispensable el Equatable para comparar states como en Bloc
class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const[],
  });


  // keep state inmutable: create new state based on the prev one
  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );

}
